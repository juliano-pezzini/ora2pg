-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sim_duplicar ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert	into simulacao(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_referencia,
	dt_inicio,
	dt_final,
	cd_convenio,
	cd_categoria,
	ds_titulo,
	ie_tipo_atendimento,
	vl_minimo,
	vl_maximo,
	qt_idade_minima,
	qt_idade_maxima,
	nr_seq_protocolo,
	nr_atendimento,
	cd_medico_resp,
	cd_especialidade,
	ie_complexidade,
	cd_procedimento,
	ie_origem_proced,
	ds_observacao,
	nr_interno_conta,
	IE_PACOTE,
	IE_CANCELADA)
SELECT 	nextval('simulacao_seq'),
	cd_estabelecimento,
	clock_timestamp(),
	nm_usuario_p,
	dt_referencia,
	dt_inicio,
	dt_final,
	cd_convenio,
	cd_categoria,
	wheb_mensagem_pck.get_texto(799534,'NM_PROTOCOLO=' || ds_titulo),
	ie_tipo_atendimento,
	vl_minimo,
	vl_maximo,
	qt_idade_minima,
	qt_idade_maxima,
	nr_seq_protocolo,
	nr_atendimento,
	cd_medico_resp,
	cd_especialidade,
	ie_complexidade,
	cd_procedimento,
	ie_origem_proced,
	ds_observacao,
	nr_interno_conta,
	coalesce(IE_PACOTE,'T'),
	coalesce(IE_CANCELADA,'S')
from	simulacao
where	nr_sequencia = nr_sequencia_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sim_duplicar ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

