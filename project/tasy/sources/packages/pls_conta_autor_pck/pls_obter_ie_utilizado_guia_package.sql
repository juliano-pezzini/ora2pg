-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conta_autor_pck.pls_obter_ie_utilizado_guia ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE

ie_retorno_w		varchar(1)	:= 'N';


BEGIN
-- se for material
if (nr_seq_guia_mat_p IS NOT NULL AND nr_seq_guia_mat_p::text <> '') then
	ie_retorno_w := pls_conta_autor_pck.pls_obter_utiliza_guia_mat(	nr_seq_guia_p, nr_seq_guia_mat_p, cd_estabelecimento_p);
-- se for procedimento
elsif (nr_seq_guia_proc_p IS NOT NULL AND nr_seq_guia_proc_p::text <> '') then
	ie_retorno_w := pls_conta_autor_pck.pls_obter_utiliza_guia_proc(	nr_seq_guia_p, nr_seq_guia_proc_p, cd_estabelecimento_p);
-- se for para toda a guia
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	ie_retorno_w := pls_conta_autor_pck.pls_obter_utiliza_guia(	nr_seq_guia_p, cd_estabelecimento_p);
end if;

return ie_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conta_autor_pck.pls_obter_ie_utilizado_guia ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
