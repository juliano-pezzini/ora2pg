-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_dt_ultima_aval_alta_html5 (nr_seq_tratamento_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		timestamp;
cd_tipo_evolucao_w	bigint;


BEGIN

if (nr_seq_tratamento_p > 0) then
	select 	max(dt_liberacao)
	into STRICT	dt_retorno_w
	from	evolucao_paciente
	where	nr_seq_rp_tratamento = nr_seq_tratamento_p
	and 	ie_tipo_evolucao = coalesce(rp_obter_tipo_evolucao_param(wheb_usuario_pck.get_cd_estabelecimento,obter_perfil_ativo),-1);
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_dt_ultima_aval_alta_html5 (nr_seq_tratamento_p bigint) FROM PUBLIC;
