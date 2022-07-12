-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_autor_utilizada_v (ie_tipo_item, nr_seq_conta, nr_seq_item, qt_procedimento, cd_procedimento, ie_origem_proced, cd_guia, cd_guia_referencia, nr_seq_guia, nr_seq_material, nr_seq_grau_partic, ie_glosa, ie_estagio_complemento, ie_status, dt_item) AS select	IE_TIPO_ITEM,NR_SEQ_CONTA,NR_SEQ_ITEM,QT_PROCEDIMENTO,CD_PROCEDIMENTO,IE_ORIGEM_PROCED,CD_GUIA,CD_GUIA_REFERENCIA,NR_SEQ_GUIA,NR_SEQ_MATERIAL,NR_SEQ_GRAU_PARTIC,IE_GLOSA,IE_ESTAGIO_COMPLEMENTO,IE_STATUS,DT_ITEM
FROM	pls_conta_autor_v
where	((ie_glosa = 'N') or (ie_glosa is null))
and	((ie_status is null) or (ie_status != 'D'));
