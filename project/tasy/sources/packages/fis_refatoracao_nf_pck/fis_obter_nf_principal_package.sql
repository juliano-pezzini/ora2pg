-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION fis_refatoracao_nf_pck.fis_obter_nf_principal ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type, nr_seq_far_venda_p far_venda.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_seq_nota_fiscal_w	nota_fiscal.nr_sequencia%type := 0;


BEGIN

begin
select	a.nr_sequencia
into STRICT	nr_seq_nota_fiscal_w
from	nota_fiscal a
where	coalesce(a.nr_sequencia_ref::text, '') = ''
and (a.nr_interno_conta = coalesce(nr_interno_conta_p, 0)
or	a.nr_seq_protocolo = coalesce(nr_seq_protocolo_p, 0)
or	a.nr_seq_far_venda = coalesce(nr_seq_far_venda_p, 0));
exception
when others then
	nr_seq_nota_fiscal_w	:=	0;
end;

return	nr_seq_nota_fiscal_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION fis_refatoracao_nf_pck.fis_obter_nf_principal ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type, nr_seq_far_venda_p far_venda.nr_sequencia%type) FROM PUBLIC;
