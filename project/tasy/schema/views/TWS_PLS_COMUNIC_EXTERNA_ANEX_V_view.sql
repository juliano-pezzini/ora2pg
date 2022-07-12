-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_comunic_externa_anex_v (nr_sequencia, dt_atualizacao, nr_seq_comunicado, ds_arquivo, nm_arquivo) AS select  a.nr_sequencia,
        a.dt_atualizacao,
        a.nr_seq_comunicado,
        pls_converte_path_storage_web(a.ds_arquivo) ds_arquivo,
        a.nm_arquivo
FROM	pls_comunic_ext_anexo_web a;
