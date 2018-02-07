{
Copyright (C) Miguel A. Risco-Castillo

FPC-markdown is a fork of Grahame Grieve <grahameg@gmail.com>
Delphi-markdown https://github.com/grahamegrieve/delphi-markdown

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
}

Unit MarkdownCommonMark;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, StrUtils, Classes, Character, TypInfo, Math, SyncObjs,
  MarkdownProcessor;

Type
  TUtilities = class
  public
    /// Reusable utility functions, not directly related to parsing or formatting data.

        /// Writes a warning to the Debug window.
    class procedure Warning(message : string; const Args: array of const);

    class function IsEscapableSymbol(c : char) : boolean;
    class function IsAsciiLetter(c : char) : boolean;
    class function IsAsciiLetterOrDigit(c : char) : boolean;
    class function IsWhitespace(c : char) : boolean;
    class procedure CheckUnicodeCategory(c : char; out space : boolean; out punctuation : boolean);

    /// Determines if the first line (ignoring the first <paramref name="startIndex"/>) of a string contains only spaces.
    class function IsFirstLineBlank(source : string; startIndex : integer) : boolean;
  end;

  TOutputFormat = (ofHtml, ofSyntaxTree, ofCustomDelegage);

  TCommonMarkSettings = class
  private
    FOutputFormat: TOutputFormat;
    FRenderSoftLineBreaksAsLineBreaks: boolean;
    FTrackSourcePosition: boolean;
  public
    Property OutputFormat : TOutputFormat read FOutputFormat write FOutputFormat;
    Property RenderSoftLineBreaksAsLineBreaks : boolean read FRenderSoftLineBreaksAsLineBreaks write FRenderSoftLineBreaksAsLineBreaks;
    property TrackSourcePosition : boolean read FTrackSourcePosition write FTrackSourcePosition;
  end;

  TMarkdownCommonMark = class(TMarkdownProcessor)
  private
  protected
  public
    Constructor Create;
    Destructor Destroy; override;

    function process(source: String): String; override;

  end;

implementation


{ TMarkdownCommonMark }

constructor TMarkdownCommonMark.Create;
begin

end;

destructor TMarkdownCommonMark.Destroy;
begin

  inherited;
end;

function TMarkdownCommonMark.process(source: String): String;
begin

end;

{ TUtilities }

class procedure TUtilities.CheckUnicodeCategory(c: char; out space, punctuation: boolean);
var
  category : TUnicodeCategory;
begin
   if (c <= '�') then
   begin
     space := (c = ' ') or ((c >= '\t') and (c <= '\r')) or (c = #$00a0) or (c = #$0085);
     punctuation := ((ord(c) >= 33) and (ord(c) <= 47)) or ((ord(c) >= 58) and (ord(c) <= 64)) or ((ord(c) >= 91) and (ord(c) <= 96)) or ((ord(c) >= 123) and (ord(c) <= 126));
   end
  else
  begin
    category := GetUnicodeCategory(c);
    space := category in [TUnicodeCategory.ucSpaceSeparator, TUnicodeCategory.ucLineSeparator, TUnicodeCategory.ucParagraphSeparator];
    punctuation := not space and (category in [TUnicodeCategory.ucConnectPunctuation, TUnicodeCategory.ucDashPunctuation, TUnicodeCategory.ucOpenPunctuation, TUnicodeCategory.ucClosePunctuation, TUnicodeCategory.ucInitialPunctuation, TUnicodeCategory.ucFinalPunctuation, TUnicodeCategory.ucOtherPunctuation]);
  end
end;

class function TUtilities.IsAsciiLetter(c: char): boolean;
begin
  result := ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z'));
end;

class function TUtilities.IsAsciiLetterOrDigit(c: char): boolean;
begin
  result := ((c >= 'a') and (c <= 'z')) or ((c >= '0') and (c <= '9')) or ((c >= 'A') and (c <= 'Z'));
end;

class function TUtilities.IsEscapableSymbol(c: char): boolean;
begin
  result := ((c > ' ') and (c < '0')) or ((c > '9') and (c < 'A')) or ((c > 'Z') and (c < 'a')) or ((c > 'z') and (ord(c) < 127)) or (c = '�');
end;

class function TUtilities.IsFirstLineBlank(source: string; startIndex: integer): boolean;
var
  c : char;
  lastIndex : integer;
begin
  lastIndex := source.Length;
  while (startIndex < lastIndex) do
  begin
    c := source[startIndex];
    if (c = #10) then
      exit(true);
    if (c <> ' ') then
      exit(false);
    inc(startIndex);
  end;
  result := true;
end;

class function TUtilities.IsWhitespace(c: char): boolean;
begin
  result := (c = ' ') or (c = #7) or (c = #13) or (c = #10) or (c = #12);
end;

class procedure TUtilities.Warning(message: string; const Args: array of const);
begin
  writeln(Format(message, args));
end;

end.
