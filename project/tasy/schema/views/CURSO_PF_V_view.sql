-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW curso_pf_v (nr_sequencia, dt_atualizacao, nm_usuario, ds_curso, ie_situacao, dt_atualizacao_nrec, nm_usuario_nrec) AS select	a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DS_CURSO,a.IE_SITUACAO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC
FROM	curso_pf a;

