-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obs_val_30 ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nm_prestador_p text, nr_seq_fornecedor_p pls_prestador.nr_sequencia%type, nm_fornecedor_p text) RETURNS varchar AS $body$
DECLARE


ds_observacao_w		varchar(2000);

BEGIN
ds_observacao_w	:= 'O material informado não está habilitado para ser administrado pelo';

-- se tiver fornecedor coloca o nome do fornecedor, senão somente o prestador
if (nr_seq_fornecedor_p IS NOT NULL AND nr_seq_fornecedor_p::text <> '') then
	ds_observacao_w := ds_observacao_w || ' fornecedor - ' || nr_seq_fornecedor_p || ' ' || nm_fornecedor_p;
else
	ds_observacao_w := ds_observacao_w || ' prestador executor desta conta - ' || nr_seq_prestador_p || ' ' || nm_prestador_p;
end if;

return ds_observacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obs_val_30 ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nm_prestador_p text, nr_seq_fornecedor_p pls_prestador.nr_sequencia%type, nm_fornecedor_p text) FROM PUBLIC;

