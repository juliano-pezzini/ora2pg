-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_wsuite_classif_bo_v (nr_sequencia, ie_situacao, nm_usuario, nr_seq_classif_oc, dt_atualizacao) AS SELECT nr_sequencia,
	ie_situacao,
	nm_usuario,
	nr_seq_classif_oc,
	dt_atualizacao
FROM wsuite_classif_boletim_oc;

