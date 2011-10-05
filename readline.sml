(* The MIT License

Copyright (c) 2011 Gian Perrone

Portions Copyright (c) 2006 Henning Niss and Ken Friis Larsen

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. *)
(* CString implementation taken from smlsqllite:                       *)
(* smlsqlite - a binding of SQLite for Standard ML.                    *)
(*                                                                     *)
(* Copyright (c) 2005, 2006 Henning Niss and Ken Friis Larsen.         *)
(* All rights reserved. See the file LICENSE for license information.  *)

signature CString =
sig
    type cstring
    val fromString : string -> cstring

    type t
    val toString : t -> string option
    val toStringVal : t -> string

    val free : t -> unit
end

structure CString :> CString =
struct
    type cstring = string
    fun fromString s = s ^ "\000"

    type t = MLton.Pointer.t

    val sub = MLton.Pointer.getWord8

    fun toVector t =
        let fun size i = if sub(t, i) = 0w0 then i
                         else size(i+1)
        in  if t <> MLton.Pointer.null then
                SOME(Word8Vector.tabulate(size 0, fn i => sub(t, i)))
            else NONE
        end

    (* FIXME: Perhaps we ought to do some UTF-8 convertion *)
    val toString = (Option.map Byte.bytesToString) o toVector
    fun toStringVal t = Option.getOpt(toString t, "")


    val free = _import "free" : t -> unit;
end

structure Readline =
struct
   val readline' = _import "sml_rl_gets" : CString.cstring -> CString.t;

   fun readline prompt =
   let
      val s = readline' (CString.fromString prompt)
      val t = CString.toString s
      val _ = CString.free s
   in
      t
   end

   val using_history = _import "using_history" : unit -> unit;
   val add_history = _import "add_history" : string -> unit;
   val clear_history = _import "clear_history" : unit -> unit;
   val stifle_history = _import "stifle_history" : int -> unit;
   val unstifle_history = _import "unstifle_history" : int -> unit;
end


