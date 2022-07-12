-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_careplan_score_v (dt_eval, nr_score, qtd, total, percentual) AS select	dt_eval,
		nr_score,
		qtd,
		total,
		round((qtd / total) * 100, 2) percentual
FROM (	select	nr_score,
				count(*) qtd,
				trunc(dt_evaluation) dt_eval,
				(
				select count(*)
				from patient_cp_indic_measure
				) total
		from	patient_cp_indic_measure
		group by
				nr_score,
				dt_evaluation
	) alias6;
