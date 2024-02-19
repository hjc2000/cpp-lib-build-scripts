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
//!  Representation of MPEG PSI/SI tables in binary form (ie. list of sections)
//!
//----------------------------------------------------------------------------

#pragma once
#include "tsAbstractDefinedByStandards.h"
#include "tsTablesPtr.h"
#include "tsTS.h"
#include "tsxml.h"
#include "tsSection.h"

namespace ts {

    class DuckContext;

    //!
    //! 以二进制形式表示MPEG PSI/SI表（即分段列表）。
    //! @ingroup mpeg
    //!
    //! 通过使用 addSection() 添加分段来构建表。
    //! 当所有分段都存在时，表变为有效。
    //!
    //! 分段使用 @link SectionPtr @endlink 安全指针添加。只复制指针，分段是共享的。
    //!
    //! 当添加第一个分段时，确定了@a table_id、@a version和分段数量。后续的分段必须具有相同的属性。
    //!
    class TSDUCKDLL BinaryTable : public AbstractDefinedByStandards
    {
    public:
        //!
        //! Default constructor.
        //!
        BinaryTable();

        //!
        //! Copy constructor.
        //! @param [in] table Another instance to copy.
        //! @param [in] mode The sections are either shared (ShareMode::SHARE) between the
        //! two tables or duplicated (ShareMode::COPY).
        //!
        BinaryTable(const BinaryTable& table, ShareMode mode);

        //!
        //! Move constructor.
        //! @param [in,out] table Another instance to move.
        //!
        BinaryTable(BinaryTable&& table) noexcept;

        //!
        //! 从分段数组构造函数。
        //! @param [in] sections 指向分段的智能指针数组。
        //! @param [in] replace 如果为true，则可以替换重复的分段。
        //! 否则，已经存在的分段（基于分段编号）不会被替换。
        //! @param [in] grow 如果为true，则分段的“last_section_number”可能大于表的当前“last_section_number”。
        //! 在这种情况下，之前添加到表中的所有分段都会被修改。
        //!
        BinaryTable(const SectionPtrVector& sections, bool replace = true, bool grow = true);

        //!
        //! Assignment operator.
        //! The sections are referenced, and thus shared between the two table objects.
        //! @param [in] table Other table to assign to this object.
        //! @return A reference to this object.
        //!
        BinaryTable& operator=(const BinaryTable& table);

        //!
        //! Move assignment operator.
        //! The sections are referenced, and thus shared between the two table objects.
        //! @param [in,out] table Other table to move into this object.
        //! @return A reference to this object.
        //!
        BinaryTable& operator=(BinaryTable&& table) noexcept;

        //!
        //! Duplication.
        //! Similar to assignment but the sections are duplicated.
        //! @param [in] table Other table to duplicate into this object.
        //! @return A reference to this object.
        //!
        BinaryTable& copy(const BinaryTable& table);

        //!
        //! Equality operator.
        //! The source PID's are ignored, only the table contents are compared.
        //! Invalid tables are never identical.
        //! @param [in] table Other table to compare.
        //! @return True if the two tables are identical. False otherwise.
        //!
        bool operator==(const BinaryTable& table) const;

#if defined(TS_NEED_UNEQUAL_OPERATOR)
        //!
        //! Unequality operator.
        //! The source PID's are ignored, only the table contents are compared.
        //! Invalid tables are never identical.
        //! @param [in] table Other table to compare.
        //! @return True if the two tables are different. False otherwise.
        //!
        bool operator!=(const BinaryTable& table) const { return !operator==(table); }
#endif

        //!
        //! 向表格中添加一个部分。
        //! 
        //! @param [in] section 一个指向部分的智能指针。
        //! 
        //! @param [in] replace 如果为真，重复的部分可以被替换。
        //! 否则，已经存在的部分（基于部分编号）将不会被替换。
        //! 
        //! @param [in] grow 如果为真，@a section 的 "last_section_number"
        //! 可能大于表格当前的 "last_section_number"。
        //! 在这种情况下，表格中先前添加的所有部分都将被修改。
        //! 
        //! @return 成功时返回真，如果 @a section 无法添加（属性不一致）则返回假。
        //!
        bool addSection(const SectionPtr& section, bool replace = true, bool grow = true);

        //!
        //! 向表格中添加多个部分。
        //! @param [in] sections 一个包含指向部分的智能指针的数组。
        //! 
        //! @param [in] replace 如果为真，重复的部分可以被替换。
        //! 否则，已经存在的部分（基于部分编号）将不会被替换。
        //! 
        //! @param [in] grow 如果为真，某个部分的 "last_section_number"
        //! 可能大于表格当前的 "last_section_number"。
        //! 在这种情况下，表格中先前添加的所有部分都将被修改。
        //! 
        //! @return 成功时返回真，如果某个部分无法添加（属性不一致）则返回假。
        //!
        bool addSections(const SectionPtrVector& sections, bool replace = true, bool grow = true)
        {
            return addSections(sections.begin(), sections.end(), replace, grow);
        }

        //!
        //! 向表格中添加多个部分。
        //! 
        //! @param [in] first 指向包含指向部分的智能指针数组的首迭代器。
        //! @param [in] last 指向包含指向部分的智能指针数组的尾迭代器。
        //! 
        //! @param [in] replace 如果为真，重复的部分可以被替换。
        //! 否则，已经存在的部分（基于部分编号）将不会被替换。
        //! 
        //! @param [in] grow 如果为真，某个部分的 "last_section_number"
        //! 可能大于表格当前的 "last_section_number"。
        //! 在这种情况下，表格中先前添加的所有部分都将被修改。
        //! 
        //! @return 成功时返回真，如果某个部分无法添加（属性不一致）则返回假。
        //!
        bool addSections(SectionPtrVector::const_iterator first, SectionPtrVector::const_iterator last, bool replace = true, bool grow = true);

        //!
        //! 打包表格中的所有部分，移除对缺失部分的引用。
        //! 举个例子，如果一个表格预期有 5 个部分（编号为 0 到 4），但只有
        //! 编号为 1 和 3 的部分存在，那么表格将被打包，现有的两个部分重新编号为 0 和 1，
        //! 并且在现有部分中将最后一个部分编号设置为 2。如果至少存在一个部分，表格就变为有效。
        //! 
        //! @return 成功时返回真，如果表格为空则返回假。
        //!
        bool packSections();

        //!
        //! Check if the table is valid.
        //! @return True if the table is valid (all consistent sections are present with same
        //! table id, same version, same "last_section_number").
        //!
        bool isValid() const {return _is_valid;}

        //!
        //! Clear the content of the table.
        //! The table must be rebuilt using calls to addSection().
        //!
        void clear();

        //!
        //! Fast access to the table id.
        //! @return The table id.
        //!
        TID tableId() const {return _tid;}

        //!
        //! Fast access to the table id extension.
        //! @return The table id extension.
        //!
        uint16_t tableIdExtension() const {return _tid_ext;}

        //!
        //! Fast access to the table version number.
        //! @return The table version number.
        //!
        uint8_t version() const {return _version;}

        /// <summary>
        ///     获取表格的源 PID。例如 PAT 表将会返回 0，即从哪个 PID 的 ts 包中构建的此表格，
        ///     就返回哪个 PID。
        /// </summary>
        /// <returns></returns>
        PID sourcePID() const {return _source_pid;}

        //!
        //! Set the table id of all sections in the table.
        //! @param [in] tid The new table id.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of all sections.
        //! If false, the CRC32's become invalid and must be computed later.
        //!
        void setTableIdExtension(uint16_t tid, bool recompute_crc = true);

        //!
        //! Set the table version number of all sections in the table.
        //! @param [in] version The new table version number.
        //! @param [in] recompute_crc If true, immediately recompute the CRC32 of all sections.
        //! If false, the CRC32's become invalid and must be computed later.
        //!
        void setVersion(uint8_t version, bool recompute_crc = true);

        //!
        //! Set the source PID of all sections in the table.
        //! @param [in] pid The new source PID.
        //!
        void setSourcePID(PID pid);

        //!
        //! Index of first TS packet of the table in the demultiplexed stream.
        //! Valid only if the table was extracted by a section demux.
        //! @return The first TS packet of the table in the demultiplexed stream.
        //!
        PacketCounter firstTSPacketIndex() const;

        //!
        //! Index of last TS packet of the table in the demultiplexed stream.
        //! Valid only if the table was extracted by a section demux.
        //! @return The last TS packet of the table in the demultiplexed stream.
        //!
        PacketCounter lastTSPacketIndex() const;

        //!
        //! Number of sections in the table.
        //! @return The number of sections in the table.
        //!
        size_t sectionCount() const
        {
            return _sections.size();
        }

        //!
        //! Total size in bytes of all sections in the table.
        //! @return The total size in bytes of all sections in the table.
        //!
        size_t totalSize() const;

        //!
        //! 传输表格所需的最少 TS 数据包数量。
        //! 
        //! @param [in] pack 如果为真，假设部分在 TS 数据包中被打包。
        //! 当为假时，假设每个部分都从一个 TS 数据包的开始处启动，
        //! 并且在每个部分的末尾应用填充。
        //! 
        //! 这个函数用于计算传输一个表格所需的最少传输流（TS）数据包数量。
        //! 'pack' 参数的意义在于，当其为 true 时，表明各部分在 TS 数据包中被紧凑地打包；
        //! 当其为 false 时，则表明每个部分均从 TS 数据包的开始处启动，并在每个部分的末尾应用填充。
        //! 这在需要优化数据传输效率的场景中尤为重要，特别是在处理流媒体或广播系统时。
        //! 
        //! @return 传输表格所需的最少 TS 数据包数量。
        //!
        PacketCounter packetCount(bool pack = true) const;

        //!
        //! Get a pointer to a section.
        //! @param [in] index Index of the section to get.
        //! @return A safe pointer to the section or a null pointer if the specified section is not present.
        //!
        const SectionPtr sectionAt(size_t index) const;

        //!
        //! Check if this is a table with one short section.
        //! @return True if this is a table with one short section.
        //!
        bool isShortSection() const;

        //!
        //! Options to convert a binary table into XML.
        //!
        class TSDUCKDLL XMLOptions
        {
        public:
            XMLOptions();       //!< Constructor.
            bool forceGeneric;  //!< Force a generic table node even if the table can be specialized.
            bool setPID;        //!< Add a metadata element with the source PID, when available.
            bool setLocalTime;  //!< Add a metadata element with the current local time.
            bool setPackets;    //!< Add a metadata element with the index of the first and last TS packets of the table.
        };

        //!
        //! This method converts the table to XML.
        //! If the table has a specialized implementation, generate a specialized XML structure.
        //! Otherwise, generate a \<generic_short_table> or \<generic_long_table> node.
        //! @param [in,out] duck TSDuck execution environment.
        //! @param [in,out] parent The parent node for the XML representation.
        //! @param [in] opt Conversion options.
        //! @return The new XML element or zero if the table is not valid.
        //!
        xml::Element* toXML(DuckContext& duck, xml::Element* parent, const XMLOptions& opt = XMLOptions()) const;

        //!
        //! This method converts an XML node as a binary table.
        //! @param [in,out] duck TSDuck execution environment.
        //! @param [in] node The root of the XML descriptor.
        //! @return True if the XML element name is a valid table name, false otherwise.
        //! If the name is valid but the content is incorrect, true is returned and this object is invalidated.
        //!
        bool fromXML(DuckContext& duck, const xml::Element* node);

        // Implementation of AbstractDefinedByStandards
        virtual Standards definingStandards() const override;

    private:
        BinaryTable(const BinaryTable& table) = delete;

        // Private fields
        bool             _is_valid;
        TID              _tid;
        uint16_t         _tid_ext;
        uint8_t          _version;
        PID              _source_pid;
        int              _missing_count;
        SectionPtrVector _sections;
    };
}
