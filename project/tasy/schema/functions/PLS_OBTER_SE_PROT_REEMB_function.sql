-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prot_reemb ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verifica se o protocolo é de reembolso
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(2);
nr_seq_protocolo_w	pls_protocolo_conta.nr_sequencia%type;
ie_tipo_protocolo_w	pls_protocolo_conta.ie_tipo_protocolo%type;


BEGIN

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then

	nr_seq_protocolo_w := nr_seq_protocolo_p;

elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	select	max(nr_seq_protocolo)
	into STRICT	nr_seq_protocolo_w
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_p;

else
	ds_retorno_w := null;
end if;

if (coalesce(nr_seq_protocolo_w,0) > 0) then
	select	max(ie_tipo_protocolo)
	into STRICT	ie_tipo_protocolo_w
	from	pls_protocolo_conta
	where	nr_sequencia = nr_seq_protocolo_w;

	if (coalesce(ie_tipo_protocolo_w,'C') = 'R') then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prot_reemb ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;
