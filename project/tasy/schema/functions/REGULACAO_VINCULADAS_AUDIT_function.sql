-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION regulacao_vinculadas_audit (nr_seq_auditoria_p bigint, cd_proc_mat_p bigint default null, ie_opcao_p text default 'P') RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_seq_requisicao_w	pls_auditoria.nr_seq_requisicao%type;
nr_seq_regulacao_w	regulacao_atend.nr_sequencia%type;


BEGIN

if (nr_seq_auditoria_p IS NOT NULL AND nr_seq_auditoria_p::text <> '') then

	select  max(nr_seq_requisicao)
	into STRICT	nr_seq_requisicao_w
	from	pls_auditoria
	where	nr_sequencia = nr_seq_auditoria_p;
	
	if ( nr_seq_requisicao_w > 0) then

		if (ie_opcao_p = 'P') then

			select  max(b.nr_seq_regulacao)
			into STRICT	nr_seq_regulacao_w
			from	pls_requisicao_proc a,
					pls_requisicao b
			where	a.nr_seq_requisicao = b.nr_sequencia
			and		b.nr_sequencia = nr_seq_requisicao_w
			and		a.cd_procedimento = cd_proc_mat_p;

		else

			select  max(b.nr_seq_regulacao)
			into STRICT	nr_seq_regulacao_w
			from	pls_requisicao_mat a,
					pls_requisicao b
			where	a.nr_seq_requisicao = b.nr_sequencia
			and		b.nr_sequencia = nr_seq_requisicao_w
			and		a.nr_seq_material = cd_proc_mat_p;

		end if;

		if (nr_seq_regulacao_w IS NOT NULL AND nr_seq_regulacao_w::text <> '') then
		
			select coalesce(obter_regulacao_vinculadas(nr_seq_equip_home, 'H'), obter_regulacao_vinculadas(nr_seq_home_care, 'E'))
			into STRICT ds_retorno_w
			from regulacao_atend
			where nr_sequencia = nr_seq_regulacao_w;
		
		end if;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION regulacao_vinculadas_audit (nr_seq_auditoria_p bigint, cd_proc_mat_p bigint default null, ie_opcao_p text default 'P') FROM PUBLIC;
