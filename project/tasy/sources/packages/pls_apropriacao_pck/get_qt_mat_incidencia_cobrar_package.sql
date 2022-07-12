-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_apropriacao_pck.get_qt_mat_incidencia_cobrar ( pls_regra_copartic_util_p pls_regra_copartic_util, pls_regra_copartic_p pls_apropriacao_pck.dados_regra_copartic) RETURNS bigint AS $body$
DECLARE

	
	dt_inicio_regra_w		timestamp;
	dt_fim_regra_w			timestamp;
	dt_item_w			timestamp := pls_apropriacao_pck.get_dt_item();
	materiais_gerados_index_w	double precision := 0;
	qt_itens_cobrar_w		double precision := 0;
	
	materiais_gerados CURSOR FOR
		SELECT	a.nr_sequencia		nr_sequencia,
			a.qt_material		qt_materiais,
			a.nr_seq_material	nr_seq_material
		from	pls_conta_mat		a,
			pls_conta		b,
			pls_protocolo_conta	c
		where	a.nr_seq_conta		= b.nr_sequencia
		and	b.nr_seq_protocolo	= c.nr_sequencia
		and	b.nr_seq_segurado	= pls_segurado_w.nr_sequencia
		and (b.ie_status('F','L'))
		and	((coalesce(a.dt_atendimento, coalesce(b.dt_atendimento_referencia, coalesce(b.dt_atendimento, c.dt_protocolo))) between dt_inicio_regra_w and dt_fim_regra_w) or (pls_regra_copartic_util_p.ie_tipo_data_consistencia = 'N'))
		and	trunc(coalesce(a.dt_atendimento, coalesce(b.dt_atendimento_referencia, coalesce(b.dt_atendimento, c.dt_protocolo))), 'dd') <= trunc(dt_item_w, 'dd');
BEGIN
	SELECT * FROM pls_apropriacao_pck.get_dt_inicio_fim_regra_incid(dt_inicio_regra_w, dt_fim_regra_w, pls_regra_copartic_util_p) INTO STRICT dt_inicio_regra_w, dt_fim_regra_w;
	
	for materiais_gerados_w in materiais_gerados loop
		if (pls_apropriacao_pck.obter_se_mat_tipo_copartic(pls_regra_copartic_p.nr_seq_tipo_coparticipacao, materiais_gerados_w.nr_seq_material) = 'S') then
			for i in materiais_gerados_index_w + 1 .. materiais_gerados_index_w + materiais_gerados_w.qt_materiais loop
				if (materiais_gerados_w.nr_sequencia = current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.nr_sequencia) and (i between coalesce(pls_regra_copartic_util_p.qt_evento_minimo, i) and coalesce(pls_regra_copartic_util_p.qt_evento_maximo, i)) then					
					qt_itens_cobrar_w := qt_itens_cobrar_w + 1;
				end if;
			end loop;
			materiais_gerados_index_w := materiais_gerados_index_w + materiais_gerados_w.qt_materiais;
		end if;
	end loop;
	
	return qt_itens_cobrar_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_apropriacao_pck.get_qt_mat_incidencia_cobrar ( pls_regra_copartic_util_p pls_regra_copartic_util, pls_regra_copartic_p pls_apropriacao_pck.dados_regra_copartic) FROM PUBLIC;
