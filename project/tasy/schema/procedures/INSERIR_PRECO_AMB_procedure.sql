-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_preco_amb ( cd_edicao_amb_p bigint, cd_procedimento_p bigint, vl_procedimento_p bigint, cd_moeda_p bigint, nm_usuario_p text, vl_custo_operacional_p bigint, vl_anestesista_p bigint, vl_medico_p bigint, vl_filme_p bigint, qt_filme_p bigint, nr_auxiliares_p bigint, nr_incidencia_p bigint, qt_porte_anestesico_p bigint, ie_origem_proced_p bigint, vl_auxiliares_p bigint, dt_inicio_vigencia_p timestamp) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	nextval('preco_amb_seq')
into STRICT	nr_sequencia_w
;

insert
into	preco_amb(cd_edicao_amb, cd_procedimento, vl_procedimento, cd_moeda, dt_atualizacao, nm_usuario, vl_custo_operacional,
	vl_anestesista, vl_medico, vl_filme, qt_filme, nr_auxiliares, nr_incidencia, qt_porte_anestesico, ie_origem_proced,
	vl_auxiliares, dt_inicio_vigencia, nr_sequencia)
values (cd_edicao_amb_p, cd_procedimento_p, vl_procedimento_p, cd_moeda_p, clock_timestamp(), nm_usuario_p, vl_custo_operacional_p,
	vl_anestesista_p, vl_medico_p, vl_filme_p, qt_filme_p, nr_auxiliares_p, nr_incidencia_p, qt_porte_anestesico_p, ie_origem_proced_p,
	vl_auxiliares_p, dt_inicio_vigencia_p, nr_sequencia_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_preco_amb ( cd_edicao_amb_p bigint, cd_procedimento_p bigint, vl_procedimento_p bigint, cd_moeda_p bigint, nm_usuario_p text, vl_custo_operacional_p bigint, vl_anestesista_p bigint, vl_medico_p bigint, vl_filme_p bigint, qt_filme_p bigint, nr_auxiliares_p bigint, nr_incidencia_p bigint, qt_porte_anestesico_p bigint, ie_origem_proced_p bigint, vl_auxiliares_p bigint, dt_inicio_vigencia_p timestamp) FROM PUBLIC;
