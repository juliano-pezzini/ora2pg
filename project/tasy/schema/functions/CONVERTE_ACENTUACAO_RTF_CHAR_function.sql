-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_acentuacao_rtf_char (ds_texto_p text) RETURNS varchar AS $body$
DECLARE


ds_texto_w	varchar(2000) := ds_texto_p;


BEGIN

ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e1', 'á');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e3', 'ã');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e0', 'à');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e2', 'â');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e4', 'ä');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e9', 'é');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'ea', 'ê');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'eb', 'ë');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'ed', 'í');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'f3', 'ó');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'f4', 'ô');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'f5', 'õ');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'fa', 'ú');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'fc', 'ü');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'e7', 'ç');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c1', 'Á');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c3', 'Ã');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c0', 'À');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c2', 'Â');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c4', 'Ä');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c9', 'É');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'ca', 'Ê');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'cb', 'Ë');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'cd', 'Í');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'd3', 'Ó');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'd4', 'Ô');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'd5', 'Õ');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'da', 'Ú');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'dc', 'Ü');
ds_texto_w := replace(ds_texto_w, '\' || CHR(39) || 'c7', 'Ç');

RETURN	ds_texto_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_acentuacao_rtf_char (ds_texto_p text) FROM PUBLIC;

