-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_texto_long_grid ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE



nr_seq_rtf_string_w	bigint;
ds_texto_long_w			varchar(32000) := '';



BEGIN

if ( ie_opcao_p = 'EF') then

	nr_seq_rtf_string_w := CONVERTE_RTF_HTML_SEM_CRLF(' 	SELECT 	DS_EVOLUCAO
							FROM  	w_evolucao_grupo_familiar
							WHERE 	nr_sequencia = :nr_sequencia_p ', nr_sequencia_p, nm_usuario_p, nr_seq_rtf_string_w);
end if;

if ( nr_seq_rtf_string_w > 0) then

	begin
	select	ds_texto
	into STRICT	ds_texto_long_w
	from	tasy_conversao_rtf
	where	nr_sequencia	= nr_seq_rtf_string_w;
	exception
	when others then
		ds_texto_long_w	:= '';
	end;

end if;

ds_retorno_p :=  ds_texto_long_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_texto_long_grid ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

