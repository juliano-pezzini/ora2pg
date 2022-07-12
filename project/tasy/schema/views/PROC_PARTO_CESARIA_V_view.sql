-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW proc_parto_cesaria_v (nr_sequencia, nr_atendimento, nr_interno_conta, cd_medico_executor, qt_parto, qt_cesaria, cd_motivo_exc_conta) AS select a.nr_sequencia,
	a.nr_atendimento,
	a.nr_interno_conta,
	a.cd_medico_executor,
	coalesce(CASE WHEN a.cd_procedimento=45080186 THEN  1 WHEN a.cd_procedimento=45080097 THEN  1 WHEN a.cd_procedimento=35001011 THEN  1 WHEN a.cd_procedimento=35006013 THEN  1 WHEN a.cd_procedimento=35025018 THEN  1  ELSE 0 END ,0) qt_parto,
	coalesce(CASE WHEN a.cd_procedimento=45080194 THEN  1 WHEN a.cd_procedimento=45080020 THEN  1 WHEN a.cd_procedimento=35009012 THEN  1 WHEN a.cd_procedimento=35026014 THEN  1  ELSE 0 END ,0) qt_cesaria,
	a.cd_motivo_exc_conta
FROM 	procedimento_paciente a
where a.cd_procedimento in (45080186, 45080097, 35001011, 35006013, 35025018, 45080194, 45080020, 35009012, 35026014);
