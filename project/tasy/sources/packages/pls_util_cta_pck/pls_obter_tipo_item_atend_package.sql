-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_util_cta_pck.pls_obter_tipo_item_atend ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

ie_tipo_item_w	varchar(2);


BEGIN
ie_tipo_item_w := null;

if (nr_seq_proc_partic_p IS NOT NULL AND nr_seq_proc_partic_p::text <> '')	then
	--PARTICIPANTE

	ie_tipo_item_w	:= 'R';
elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '')	then
	--PROCEDIMENTO

	ie_tipo_item_w	:= 'P';
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '')	then
	--MATERIAL

	ie_tipo_item_w	:= 'M';
elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '')	then
	--CONTA

	ie_tipo_item_w	:= 'C';
end if;

return	ie_tipo_item_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_cta_pck.pls_obter_tipo_item_atend ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type) FROM PUBLIC;