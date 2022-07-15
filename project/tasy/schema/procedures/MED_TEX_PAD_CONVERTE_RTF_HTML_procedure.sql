-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_tex_pad_converte_rtf_html ( nr_sequencia_p text, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE




ds_out_w		varchar(10) := '0';
ds_retorno_w	text;


BEGIN

ds_out_w := converte_rtf_html('select ds_texto from med_texto_padrao where nr_sequencia = :nr_sequencia', nr_sequencia_p, nm_usuario_p, ds_out_w);

if (ds_out_w IS NOT NULL AND ds_out_w::text <> '') then
	begin
	select	ds_texto
	into STRICT	ds_retorno_w
	from	tasy_conversao_rtf
	where	nr_sequencia = ds_out_w;
	end;
end if;

ds_retorno_p	:= ds_retorno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_tex_pad_converte_rtf_html ( nr_sequencia_p text, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

