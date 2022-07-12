-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW iniciacao_v (nr_pendencia, ds_pendencia, nr_sequencia, nr_seq_cliente) AS select  nr_pendencia,
 ds_pendencia,
 nr_sequencia,
 nr_seq_cliente
FROM iniciacao_repasse_v a

union

select  nr_pendencia,
 ds_pendencia,
 nr_sequencia,
 nr_seq_cliente
from iniciacao_acordo_v;

