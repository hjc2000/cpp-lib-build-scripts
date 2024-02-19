//----------------------------------------------------------------------------
//
// TSDuck - The MPEG Transport Stream Toolkit
// Copyright (c) 2005-2023, Thierry Lelegard
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGE.
//
//----------------------------------------------------------------------------
//!
//!  @file
//!  Representation of MPEG PSI/SI sections
//!
//----------------------------------------------------------------------------

#pragma once
#include "tsAbstractDefinedByStandards.h"
#include "tsDemuxedData.h"
#include "tsCerrReport.h"
#include "tsByteBlock.h"
#include "tsCRC32.h"
#include "tsETID.h"
#include "tsTS.h"

namespace ts {
    //!
    //! MPEG PSI/SI（Program Specific Information / Service Information）部分的表示。
    //! @ingroup mpeg
    //!
    //! 在构建部分时，CRC32 的处理方式取决于名为 @a crc_op 的参数：
    //!
    //! - IGNORE:  不检查也不计算 CRC。
    //! - CHECK:   验证部分数据中的 CRC。如果 CRC 不正确，则标记部分为无效。
    //! - COMPUTE: 计算 CRC 并将其存储在部分中。
    //!
    //! 通常情况下，如果 ByteBlock 来自网络，请使用 CHECK。
    //! 如果 ByteBlock 由应用程序构建，请使用 COMPUTE。
    //!
    class TSDUCKDLL Section : public DemuxedData, public AbstractDefinedByStandards
    {
    public:
        //!
        //! Explicit identification of super class.
        //!
        typedef DemuxedData SuperClass;

        //!
        //! Default constructor.
        //! Section is initially marked invalid.
        //!
        Section();

        //!
        //! Copy constructor.
        //! @param [in] other Another instance to copy.
        //! @param [in] mode The section's data are either shared (ShareMode::SHARE) between the
        //! two instances or duplicated (ShareMode::COPY).
        //!
        Section(const Section& other, ShareMode mode);

        //!
        //! Constructor from full binary content.
        //! The content is copied into the section if valid.
        //! @param [in] content Address of the binary section data.
        //! @param [in] content_size Size in bytes of the section.
        //! @param [in] source_pid PID from which the section was read.
        //! @param [in] crc_op How to process the CRC32.
        //!
        Section(const void* content,
                size_t content_size,
                PID source_pid = PID_NULL,
                CRC32::Validation crc_op = CRC32::Validation::IGNORE);

        //!
        //! Constructor from full binary content.
        //! The content is copied into the section if valid.
        //! @param [in] content Binary section data.
        //! @param [in] source_pid PID from which the section was read.
        //! @param [in] crc_op How to process the CRC32.
        //!
        Section(const ByteBlock& content,
                PID source_pid = PID_NULL,
                CRC32::Validation crc_op = CRC32::Validation::IGNORE);

        //!
        //! Constructor from full binary content.
        //! The content is copied into the section if valid.
        //! @param [in] content_ptr Safe pointer to the binary section data.
        //! The content is referenced, and thus shared.
        //! Do not modify the referenced ByteBlock from outside the Section.
        //! @param [in] source_pid PID from which the section was read.
        //! @param [in] crc_op How to process the CRC32.
        //!
        Section(const ByteBlockPtr& content_ptr,
                PID source_pid = PID_NULL,
                CRC32::Validation crc_op = CRC32::Validation::IGNORE);

        //!
        //! Constructor from a short section payload.
        //! @param [in] tid Table id.
        //! @param [in] is_private_section If true, this is a private section (ie. not MPEG-defined).
        //! @param [in] payload Address of the payload data.
        //! @param [in] payload_size Size in bytes of the payload data.
        //! @param [in] source_pid PID from which the section was read.
        //!
        Section(TID tid,
                bool is_private_section,
                const void* payload,
                size_t payload_size,
                PID source_pid = PID_NULL);

        //!
        //! 从长部分有效载荷构造函数。
        //! 提供的有效载荷不包含 CRC32。
        //! CRC32 将自动计算。
        //! 
        //! @param [in] tid 表格标识符。
        //! @param [in] is_private_section 如果为真，这是一个私有部分（即非 MPEG 定义的部分）。
        //! @param [in] tid_ext 表格标识符扩展。
        //! @param [in] version 部分版本号。
        //! @param [in] is_current 如果为真，这是一个“当前”部分，而不是“下一个”部分。
        //! @param [in] section_number 部分编号。
        //! @param [in] last_section_number 表格中的最后一个部分的编号。
        //! @param [in] payload 数据有效载荷的地址。
        //! @param [in] payload_size 数据有效载荷的字节大小。
        //! @param [in] source_pid 读取部分的源 PID。
        //!
        Section(TID tid,
                bool is_private_section,
                uint16_t tid_ext,
                uint8_t version,
                bool is_current,
                uint8_t section_number,
                uint8_t last_section_number,
                const void* payload,
                size_t payload_size,
                PID source_pid = PID_NULL);

        // Inherited methods.
        virtual void clear() override;
        virtual void reload(const void* content, size_t content_size, PID source_pid = PID_NULL) override;
        virtual void reload(const ByteBlock& content, PID source_pid = PID_NULL) override;
        virtual void reload(const ByteBlockPtr& content_ptr, PID source_pid = PID_NULL) override;
        virtual Standards definingStandards() const override;

        //!
        //! Reload from full binary content.
        //! The content is copied into the section if valid.
        //! @param [in] content Address of the binary section data.
        //! @param [in] content_size Size in bytes of the section.
        //! @param [in] source_pid PID from which the section was read.
        //! @param [in] crc_op How to process the CRC32.
        //!
        void reload(const void* content, size_t content_size, PID source_pid, CRC32::Validation crc_op);

        //!
        //! Reload from full binary content.
        //! @param [in] content Binary section data.
        //! @param [in] source_pid PID from which the section was read.
        //! @param [in] crc_op How to process the CRC32.
        //!
        void reload(const ByteBlock& content, PID source_pid, CRC32::Validation crc_op);

        //!
        //! Reload from full binary content.
        //! @param [in] content_ptr Safe pointer to the binary section data.
        //! The content is referenced, and thus shared.
        //! Do not modify the referenced ByteBlock from outside the Section.
        //! @param [in] source_pid PID from which the section was read.
        //! @param [in] crc_op How to process the CRC32.
        //!
        void reload(const ByteBlockPtr& content_ptr, PID source_pid, CRC32::Validation crc_op);

        //!
        //! Reload from a short section payload.
        //! @param [in] tid Table id.
        //! @param [in] is_private_section If true, this is a private section (ie. not MPEG-defined).
        //! @param [in] payload Address of the payload data.
        //! @param [in] payload_size Size in bytes of the payload data.
        //! @param [in] source_pid PID from which the section was read.
        //!
        void reload(TID tid, bool is_private_section, const void* payload, size_t payload_size, PID source_pid = PID_NULL);

        //!
        //! Reload from a long section payload.
        //! The provided payload does not contain the CRC32.
        //! The CRC32 is automatically computed.
        //! @param [in] tid Table id.
        //! @param [in] is_private_section If true, this is a private section (ie. not MPEG-defined).
        //! @param [in] tid_ext Table id extension.
        //! @param [in] version Section version number.
        //! @param [in] is_current If true, this is a "current" section, not a "next" section.
        //! @param [in] section_number Section number.
        //! @param [in] last_section_number Number of last section in the table.
        //! @param [in] payload Address of the payload data.
        //! @param [in] payload_size Size in bytes of the payload data.
        //! @param [in] source_pid PID from which the section was read.
        //!
        void reload(TID tid,
                    bool is_private_section,
                    uint16_t tid_ext,
                    uint8_t version,
                    bool is_current,
                    uint8_t section_number,
                    uint8_t last_section_number,
                    const void* payload,
                    size_t payload_size,
                    PID source_pid = PID_NULL);

        //!
        //! Assignment operator.
        //! The sections contents are referenced, and thus shared between the two section objects.
        //! @param [in] other Other section to assign to this object.
        //! @return A reference to this object.
        //!
        Section& operator=(const Section& other);

        //!
        //! Move assignment operator.
        //! @param [in,out] other Other section to move into this object.
        //! @return A reference to this object.
        //!
        Section& operator=(const Section&& other) noexcept;

        //!
        //! Duplication.
        //! Similar to assignment but the sections are duplicated.
        //! @param [in] other Other section to duplicate into this object.
        //! @return A reference to this object.
        //!
        Section& copy(const Section& other);

        //!
        //! Check if the section has valid content.
        //! @return True if the section has valid content.
        //!
        bool isValid() const { return _is_valid; }

        //!
        //! Equality operator.
        //! The source PID's are ignored, only the section contents are compared.
        //! Invalid sections are never identical.
        //! @param [in] other Other section to compare.
        //! @return True if the two sections are identical. False otherwise.
        //!
        bool operator==(const Section& other) const;

#if defined(TS_NEED_UNEQUAL_OPERATOR)
        //!
        //! Unequality operator.
        //! The source PID's are ignored, only the section contents are compared.
        //! Invalid sections are never identical.
        //! @param [in] other Other section to compare.
        //! @return True if the two sections are different. False otherwise.
        //!
        bool operator!=(const Section& other) const { return !operator==(other); }
#endif

        //!
        //! Get the table id.
        //! @return The table id or TID_NULL if the table is invalid.
        //!
        TID tableId() const { return _is_valid ? content()[0] : uint8_t(TID_NULL); }

        //!
        //! This static method checks if a data area of at least 3 bytes can be the start of a long section.
        //! @param [in] data Address of the data area.
        //! @param [in] size Size in bytes of the data area.
        //! @return True if the section is a long one.
        //!
        static bool StartLongSection(const uint8_t* data, size_t size);

        //!
        //! Check if the section is a long one.
        //! @return True if the section is a long one.
        //!
        bool isLongSection() const { return _is_valid && StartLongSection(content(), size()); }

        //!
        //! Check if the section is a short one.
        //! @return True if the section is a short one.
        //!
        bool isShortSection() const { return _is_valid && !isLongSection(); }

        //!
        //! Check if the section is a private one (ie. not MPEG-defined).
        //! @return True if the section is a private one (ie. not MPEG-defined).
        //!
        bool isPrivateSection() const { return _is_valid && (content()[1] & 0x40) != 0; }

        //!
        //! Get the table id extension (long section only).
        //! @return The table id extension.
        //!
        uint16_t tableIdExtension() const { return isLongSection() ? GetUInt16(content() + 3) : 0; }

        //!
        //! Get the section version number (long section only).
        //! @return The section version number.
        //!
        uint8_t version() const { return isLongSection() ? ((content()[5] >> 1) & 0x1F) : 0; }

        //!
        //! Check if the section is "current", not "next" (long section only).
        //! @return True if the section is "current", false if it is "next".
        //!
        bool isCurrent() const { return isLongSection() && (content()[5] & 0x01) != 0; }

        //!
        //! Check if the section is "next", not "current" (long section only).
        //! @return True if the section is "next", false if it is "current".
        //!
        bool isNext() const { return isLongSection() && (content()[5] & 0x01) == 0; }

        //!
        //! Get the section number in the table (long section only).
        //! @return The section number in the table.
        //!
        uint8_t sectionNumber() const { return isLongSection() ? content()[6] : 0; }

        //!
        //! Get the number of the last section in the table (long section only).
        //! @return The number of the last section in the table.
        //!
        uint8_t lastSectionNumber() const { return isLongSection() ? content()[7] : 0; }

        //!
        //! Get the table id and id extension (long section only).
        //! @return The table id and id extension as an ETID.
        //!
        ETID etid() const { return isLongSection() ? ETID(tableId(), tableIdExtension()) : ETID(tableId()); }

        //!
        //! Size of the section header.
        //! @return Size of the section header.
        //!
        size_t headerSize() const { return _is_valid ? (isLongSection() ? LONG_SECTION_HEADER_SIZE : SHORT_SECTION_HEADER_SIZE) : 0; }

        // 访问部分的有效负载。
        //
        // 对于短的部分，有效负载从private_section_length字段之后开始。
        // 对于长的部分，有效负载从最后一个section_number字段之后开始，并在CRC32字段之前结束。
        // 不要修改有效负载的内容。在部分被修改后，有效负载可能会失效。
        //
        // @return 部分有效负载的地址。
        const uint8_t* payload() const
        {
            return _is_valid ? (content() + (isLongSection() ? LONG_SECTION_HEADER_SIZE : SHORT_SECTION_HEADER_SIZE)) : nullptr;
        }

        //!
        //! 获取部分的有效载荷大小。
        //! 对于长部分，有效载荷在CRC32字段之前结束。
        //! 
        //! @return 部分有效载荷的字节大小。
        //!
        size_t payloadSize() const
        {
            return _is_valid ? size() - (isLongSection() ? LONG_SECTION_HEADER_SIZE + SECTION_CRC32_SIZE : SHORT_SECTION_HEADER_SIZE) : 0;
        }

        //!
        //! Get a hash of the section content.
        //! @return SHA-1 value of the section content.
        //!
        ByteBlock hash() const;

        //!
        //! Minimum number of TS packets required to transport the section.
        //! @return The minimum number of TS packets required to transport the section.
        //!
        PacketCounter packetCount() const {return SectionPacketCount(size());}

        //!
        //! Set the table id.
        //! @param [in] tid The table id.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setTableId(uint8_t tid, bool recompute_crc = true);

        //!
        //! Set the table id extension (long section only).
        //! @param [in] tid_ext The table id extension.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setTableIdExtension(uint16_t tid_ext, bool recompute_crc = true);

        //!
        //! Set the section version number (long section only).
        //! @param [in] version The section version number.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setVersion(uint8_t version, bool recompute_crc = true);

        //!
        //! Set the section current/next flag (long section only).
        //! @param [in] is_current True if the table is "current", false if it is "next".
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setIsCurrent(bool is_current, bool recompute_crc = true);

        //!
        //! Set the section number (long section only).
        //! @param [in] num The section number.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setSectionNumber(uint8_t num, bool recompute_crc = true);

        //!
        //! Set the number of the last section in the table (long section only).
        //! @param [in] num The number of the last section in the table.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setLastSectionNumber(uint8_t num, bool recompute_crc = true);

        //!
        //! Set one byte in the payload of the section.
        //! @param [in] offset Byte offset in the payload.
        //! @param [in] value The value to set in the payload.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setUInt8(size_t offset, uint8_t value, bool recompute_crc = true);

        //!
        //! Set a 16-bit integer in the payload of the section.
        //! @param [in] offset Byte offset in the payload.
        //! @param [in] value The value to set in the payload.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setUInt16(size_t offset, uint16_t value, bool recompute_crc = true);

        //!
        //! Set a 32-bit integer in the payload of the section.
        //! @param [in] offset Byte offset in the payload.
        //! @param [in] value The value to set in the payload.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void setUInt32(size_t offset, uint32_t value, bool recompute_crc = true);

        //!
        //! 将二进制数据附加到部分的有效载荷。
        //! 
        //! @param [in] data 要添加到有效载荷的数据的地址。
        //! @param [in] size 要添加到有效载荷的数据的字节大小。
        //! @param [in] recompute_crc 如果为真，则立即重新计算部分的 CRC32。
        //!
        void appendPayload(const void* data, size_t size, bool recompute_crc = true);

        //!
        //! 将二进制数据附加到部分的有效载荷。
        //! 
        //! @param [in] data 要添加到有效载荷的字节块。
        //! @param [in] recompute_crc 如果为真，则立即重新计算部分的 CRC32。
        //!
        void appendPayload(const ByteBlock& data, bool recompute_crc = true)
        {
            appendPayload(data.data(), data.size(), recompute_crc);
        }

        //!
        //! Truncate the payload of the section.
        //! @param [in] size New size in bytes of the payload. If larger than the current
        //! payload size, does nothing.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of the section.
        //!
        void truncatePayload(size_t size, bool recompute_crc = true);

        //!
        //! This method recomputes and replaces the CRC32 of the section.
        //!
        void recomputeCRC();

        //!
        //! 检查部分是否具有“多样化”的有效载荷。
        //! 如果有效载荷的大小为2字节或更多，并且包含至少2个不同的字节值（不全为0x00或不全为0xFF等），
        //! 则有效载荷被认为是“多样化”的。
        //! 
        //! @return 如果有效载荷是多样化的，则返回真。
        //!
        bool hasDiversifiedPayload() const;

        //!
        //! 从标准流（二进制模式）中读取一个部分。
        //! 
        //! @param [in,out] strm 输入模式下的标准流。
        //! 如果一个部分无效（在部分结束之前到达文件末尾，CRC 错误），
        //! 流的 failbit 会被设置。
        //! 
        //! @param [in] crc_op 如何处理输入包的 CRC32。
        //! @param [in,out] report 用于报告错误的位置。
        //! 
        //! @return 对 @a strm 对象的引用。
        //!
        std::istream& read(std::istream& strm, CRC32::Validation crc_op = CRC32::Validation::IGNORE, Report& report = CERR);

        //!
        //! 将一个部分写入标准流（二进制模式）。
        //! 
        //! @param [in,out] strm 输出模式下的标准流。
        //! @param [in,out] report 用于报告错误的位置。
        //! 
        //! @return 对 @a strm 对象的引用。
        //!
        std::ostream& write(std::ostream& strm, Report& report = CERR) const;

        //!
        //! 将部分以十六进制形式转储到输出流，不解释有效载荷。
        //! 
        //! @param [in,out] strm 输出模式下的标准流（文本模式）。
        //! @param [in] indent 行的基本缩进。
        //! @param [in] cas CAS id，用于 CAS 特定信息。
        //! @param [in] no_header 如果为真，不显示部分头部。
        //! 
        //! @return 对 @a strm 对象的引用。
        //!
        std::ostream& dump(std::ostream& strm, int indent = 0, uint16_t cas = CASID_NULL, bool no_header = false) const;

        //!
        //! Static method to compute a section size.
        //! @param [in] content Address of the binary section data.
        //! @param [in] content_size Size in bytes of the buffer containing the section and possibly trailing additional data.
        //! @return The total size in bytes of the section starting at @a content or zero on error.
        //!
        static size_t SectionSize(const void* content, size_t content_size);

        //!
        //! Static method to compute a section size.
        //! @param [in] content Buffer containing the section and possibly trailing additional data.
        //! @return The total size in bytes of the section starting in @a content or zero on error.
        //!
        static size_t SectionSize(const ByteBlock& content) { return SectionSize(content.data(), content.size()); }

        //!
        //! 计算传输一组部分所需的最小 TS 数据包数量的静态方法。
        //! 
        //! @tparam CONTAINER 一个包含 SectionPtr 的容器类，符合 C++ 标准模板库（STL）的定义。
        //! @param [in] container 一个 SectionPtr 容器类。
        //! 
        //! @param [in] pack 如果为真，假设部分在 TS 数据包中被打包。
        //! 当为假时，假设每个部分都从一个 TS 数据包的开始处启动，
        //! 并且在每个部分的末尾应用填充。
        //! 
        //! @return 传输 @a container 中的部分所需的最小 TS 数据包数量。
        //!
        template <class CONTAINER>
        static PacketCounter PacketCount(const CONTAINER& container, bool pack = true);

    private:
        // Private fields
        bool _is_valid;

        // Validate binary content.
        void validate(CRC32::Validation);

        // Inaccessible operations
        Section(const Section&) = delete;
    };
}

#include "tsSectionTemplate.h"
