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
//!  Table handler interface.
//!
//----------------------------------------------------------------------------

#pragma once
#include "tsPlatform.h"

namespace ts {

    class BinaryTable;
    class SectionDemux;

    //!
    //! Table handler interface.
    //! @ingroup mpeg
    //!
    //! This abstract interface must be implemented by classes which need to be
    //! notified of tables using a SectionDemux.
    //!
    class TSDUCKDLL TableHandlerInterface
    {
    public:
        //!
        //! 当完整的表可用时，将调用此钩子。
        //! 仅当有新版本可用时才报告具有长分段的表。
        //! @param [in,out] demux 对分段解复用器的引用。
        //! @param [in] table 对解复用的表的引用。
        //!
        virtual void handleTable(SectionDemux& demux, const BinaryTable& table) = 0;

        //!
        //! Virtual destructor.
        //!
        virtual ~TableHandlerInterface();
    };
}
