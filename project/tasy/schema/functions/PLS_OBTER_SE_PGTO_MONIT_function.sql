-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_pgto_monit (nr_seq_conta_p pls_conta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_gera_w			varchar(1) := 'S';
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_estabelecimento_ww		estabelecimento.cd_estabelecimento%type;
nr_seq_prestador_exec_w		pls_prestador.nr_sequencia%type;
nr_seq_prest_inter_w		pls_prestador_intercambio.nr_sequencia%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_cgc_w			pessoa_juridica.cd_cgc%type;
cd_cnpj_cpf_w			pessoa_juridica.cd_cgc%type;
cd_cnpj_oper_w			pls_outorgante.cd_cgc_outorgante%type;


BEGIN
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	select	nr_seq_prestador_exec,
		nr_seq_prest_inter,
		cd_pessoa_fisica,
		cd_cgc,
		cd_estabelecimento
	into STRICT	nr_seq_prestador_exec_w,
		nr_seq_prest_inter_w,
		cd_pessoa_fisica_w,
		cd_cgc_w,
		cd_estabelecimento_ww
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_p;
end if;

if (coalesce(cd_estabelecimento_w::text, '') = '') then
	cd_estabelecimento_w := cd_estabelecimento_ww;
end if;

select	max(cd_cgc_outorgante)
into STRICT	cd_cnpj_oper_w
from	pls_outorgante
where	cd_estabelecimento = cd_estabelecimento_w;

if (nr_seq_prestador_exec_w IS NOT NULL AND nr_seq_prestador_exec_w::text <> '') then

	select	cd_cgc,
		cd_pessoa_fisica
	into STRICT	cd_cgc_w,
		cd_pessoa_fisica_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_exec_w;

elsif (nr_seq_prest_inter_w IS NOT NULL AND nr_seq_prest_inter_w::text <> '') then

	select	coalesce(nr_cpf,cd_cgc_intercambio)
	into STRICT	cd_cnpj_cpf_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_inter_w;
end if;

if (coalesce(cd_cnpj_cpf_w::text, '') = '') then
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		select	nr_cpf
		into STRICT	cd_cnpj_cpf_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	else
		cd_cnpj_cpf_w := cd_cgc_w;
	end if;
end if;

if (substr(cd_cnpj_cpf_w,1,8) = substr(cd_cnpj_oper_w,1,8)) then
	ie_gera_w := 'N';
end if;

return	ie_gera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_pgto_monit (nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;
