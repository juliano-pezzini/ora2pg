-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_copiar_tabela_proc_pab ( dt_comp_origem_p timestamp, dt_comp_destino_p timestamp, nm_usuario_p text) AS $body$
DECLARE



qt_registro_w	integer	:= 0;



BEGIN

select	count(*)
into STRICT	qt_registro_w
from	sus_preco_municipio
where	dt_competencia	= dt_comp_destino_p;

if (qt_registro_w	> 0) then
	--r.aise_application_error(-20011, 'Data de competência já existente na tabela PAB. #@#@');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263438);
end if;

insert into sus_preco_municipio(nr_sequencia,
	dt_competencia,
	vl_sa,
	vl_total_hospitalar,
	vl_sp,
	vl_sh,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_municipio_ibge,
	cd_procedimento,
	ie_origem_proced)
SELECT	nextval('sus_preco_municipio_seq'),
	dt_comp_destino_p,
	vl_sa,
	vl_total_hospitalar,
	vl_sp,
	vl_sh,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_municipio_ibge,
	cd_procedimento,
	ie_origem_proced
from	sus_preco_municipio
where	dt_competencia	= dt_comp_origem_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_copiar_tabela_proc_pab ( dt_comp_origem_p timestamp, dt_comp_destino_p timestamp, nm_usuario_p text) FROM PUBLIC;
