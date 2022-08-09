-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_duplicar_regra ( nr_seq_regra_p bigint, ie_tipo_regra_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* IE_REGRA_P
	4 - Regras do Anexo IV (SIP_REGRA_CRITERIO)
*/
BEGIN

insert into sip_regra_criterio(nr_sequencia,
	nr_seq_regra_sip,
	ie_estrutura,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_procedimento,
	ie_origem_proced,
	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_cid_principal,
	nr_seq_saida_int,
	qt_idade_min,
	qt_idade_max,
	cd_estabelecimento)
SELECT	nextval('sip_regra_criterio_seq'),
	nr_seq_regra_sip,
	ie_estrutura,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_procedimento,
	ie_origem_proced,
	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_cid_principal,
	nr_seq_saida_int,
	qt_idade_min,
	qt_idade_max,
	cd_estabelecimento
from	sip_regra_criterio
where	nr_sequencia	= nr_seq_regra_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_duplicar_regra ( nr_seq_regra_p bigint, ie_tipo_regra_p bigint, nm_usuario_p text) FROM PUBLIC;
