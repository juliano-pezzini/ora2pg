-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_date_formaters.getdatelanguagefromtag (language_tag_p text) RETURNS varchar AS $body$
DECLARE

language_tags_p varchar(20);

BEGIN
BEGIN


    if (language_tag_p = 'ar_SA') then
return 'ARABIC';
elsif (language_tag_p = 'de_AT') then
return 'GERMAN';
elsif (language_tag_p = 'de_DE') then
return 'GERMAN';
elsif (language_tag_p = 'en_AU') then
return 'ENGLISH';
elsif (language_tag_p = 'en_GB') then
return 'ENGLISH';
elsif (language_tag_p = 'en_US') then
return 'AMERICAN';
elsif (language_tag_p = 'es_AR') then
return 'LATIN AMERICAN SPANISH';
elsif (language_tag_p = 'es_BO') then
return 'LATIN AMERICAN SPANISH';
elsif (language_tag_p = 'es_CO') then
return 'LATIN AMERICAN SPANISH';
elsif (language_tag_p = 'es_DO') then
return 'LATIN AMERICAN SPANISH';
elsif (language_tag_p = 'es_MX') then
return 'MEXICAN SPANISH';
elsif (language_tag_p = 'ja_JP') then
return 'JAPANESE';
elsif (language_tag_p = 'pl_PL') then
return 'POLISH';
elsif (language_tag_p = 'pt_BR') then
return 'BRAZILIAN PORTUGUESE';
else
return 'BRAZILIAN PORTUGUESE';
end if;


end;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pkg_date_formaters.getdatelanguagefromtag (language_tag_p text) FROM PUBLIC;
