-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_revisao_doc (nr_seq_documento_p bigint) RETURNS varchar AS $body$
DECLARE


	cd_funcao_gestao_qualidade_w 	smallint := 4000;
	cd_par_gerar_codigo_revisao_w	smallint := 227;
	ds_retorno_w			varchar(20);
	ie_gerar_codigo_revisao_w 	varchar(1);
	

BEGIN
	ie_gerar_codigo_revisao_w := obter_parametro_funcao(cd_funcao_gestao_qualidade_w,
							cd_par_gerar_codigo_revisao_w,
							wheb_usuario_pck.get_nm_usuario);
	
	if (coalesce(ie_gerar_codigo_revisao_w, 'S') = 'S') then
		select max(somente_numero(a.cd_revisao))
		into STRICT	ds_retorno_w
		from	qua_doc_revisao a
		where	a.nr_seq_doc = nr_seq_documento_p
		and 	coalesce(somente_nao_numero(a.cd_revisao)::text, '') = '';
	else
		select a.cd_revisao
		into STRICT   ds_retorno_w
		from   qua_doc_revisao a 
		where  a.nr_seq_doc = nr_seq_documento_p 
		and    a.nr_sequencia = (SELECT max(qdr.nr_sequencia) from qua_doc_revisao qdr where qdr.nr_seq_doc = nr_seq_documento_p);
		end if;
	return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_revisao_doc (nr_seq_documento_p bigint) FROM PUBLIC;

