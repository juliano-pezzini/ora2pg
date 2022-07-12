-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW audc_itens_guia_v (nr_seq_plano_item, ie_tipo_item, cd_item, ie_origem_proced, ds_item, cd_guia, dt_liberacao, ie_status, qt_solicitada, qt_autorizada, nr_seq_guia, nr_seq_segurado, nr_seq_prestador) AS select  a.nr_sequencia nr_seq_plano_item,
        'P' ie_tipo_item,
        a.cd_procedimento cd_item,
        a.ie_origem_proced,
        obter_desc_procedimento(a.cd_procedimento, a.ie_origem_proced) ds_item,
        b.cd_guia,
        a.dt_liberacao,
        a.ie_status,
        a.qt_solicitada,
        a.qt_autorizada,
        a.nr_seq_guia,
	b.nr_seq_segurado,
	b.nr_seq_prestador
FROM    pls_guia_plano_proc a,
        pls_guia_plano b
where   a.nr_seq_guia = b.nr_sequencia

union

select  a.nr_sequencia nr_seq_plano_item,
        'M' ie_tipo_item,
        a.nr_seq_material cd_item,
        null ie_origem_proced,
        substr(pls_obter_desc_material(nr_seq_material),1,255) ds_item,
        b.cd_guia,
        a.dt_liberacao,
        a.ie_status,
        a.qt_solicitada,
        a.qt_autorizada,
        a.nr_seq_guia,
	b.nr_seq_segurado,
	b.nr_seq_prestador
from    pls_guia_plano_mat a,
        pls_guia_plano b
where   a.nr_seq_guia = b.nr_sequencia;

