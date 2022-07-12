-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_chamado_pck.get_ds_motivo_encerramento ( nr_seq_motivo_encerramento_p pls_motivo_final_chamado.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

ds_motivo_encerramento_w	pls_motivo_final_chamado.ds_motivo%type;

BEGIN
select	max(ds_motivo)
into STRICT	ds_motivo_encerramento_w
from	pls_motivo_final_chamado
where	nr_sequencia	= nr_seq_motivo_encerramento_p;
return ds_motivo_encerramento_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_chamado_pck.get_ds_motivo_encerramento ( nr_seq_motivo_encerramento_p pls_motivo_final_chamado.nr_sequencia%type) FROM PUBLIC;
