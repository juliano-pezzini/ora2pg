-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pessoa_doc_valid_v (cd_pessoa_fisica, ds_arquivo, nr_seq_documento, dt_atualizacao_nrec, nm_usuario_nrec, dt_validade, ie_finalidade) AS select     pdoc.cd_pessoa_fisica,
           pdoc.ds_arquivo,
           pdoc.nr_seq_documento,
           pdoc.dt_atualizacao_nrec,
           pdoc.nm_usuario_nrec,
           pdoc.dt_validade,
           tpdoc.ie_finalidade
   FROM  pessoa_documentacao pdoc,
         tipo_documentacao   tpdoc
   where pdoc.nr_seq_documento = tpdoc.nr_sequencia
   and pdoc.dt_validade is not null
   and  trunc(pdoc.dt_validade) >= trunc(LOCALTIMESTAMP)
   and tpdoc.ie_finalidade ='I';
