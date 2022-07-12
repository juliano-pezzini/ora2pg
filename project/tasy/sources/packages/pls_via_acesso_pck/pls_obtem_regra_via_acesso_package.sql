-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_via_acesso_pck.pls_obtem_regra_via_acesso ( dados_conta_p pls_via_acesso_pck.dados_conta, nm_usuario_p usuario.nm_usuario%type) RETURNS varchar AS $body$
DECLARE
	
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
Rotina que obtém as regras de via de acesso cabiveis sobre a conta, será retornada uma lista de regras
que serão aplicadas uma a uma dentro da rotina pls_aplicar_via_acesso_conta
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ X]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_w		varchar(4000);
nr_seq_regra_aux_w	pls_tipo_via_acesso.nr_sequencia%type	:= 0;
ie_simultaneo_w		varchar(1);
ds_retorno_w		varchar(4000);

C00 CURSOR(	nr_seq_conta_pc		pls_conta_proc_v.nr_seq_conta%type)FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced,
		a.dt_procedimento_trunc,
		a.hr_inicio_proc,
		a.hr_fim_proc
	from	pls_conta_proc_v	a
	where	a.nr_seq_conta		= nr_seq_conta_pc
	and	a.ie_via_obrigatoria 	= 'S'
	order by a.cd_procedimento,
		a.ie_origem_proced,
		a.dt_procedimento,
		a.dt_inicio_proc,
		a.dt_fim_proc,
		a.nr_sequencia;

-- Ler as regras de via de acesso onde os procedimentos da regra de encaixam com os procedimentos da conta
C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_tipo_via_acesso	a,
		pls_proc_via_acesso	b
	where	a.nr_sequencia		= b.nr_seq_regra
	and	a.ie_situacao		= 'A'
	group by a.nr_sequencia
	order by count(b.nr_sequencia),
		sum(b.qt_procedimento);
BEGIN

nr_seq_regra_w	:= null;

for r_C00 in C00(dados_conta_p.nr_seq_conta) loop
	begin
	for r_C01 in C01 loop
		begin
		--Ponto mais importante da procedure onde é verificado se a regra é válida para a verificação do procedimento da conta.
		ie_simultaneo_w	:= pls_via_acesso_pck.pls_obter_conta_simul(r_C00.dt_procedimento_trunc, r_C00.hr_inicio_proc, dados_conta_p, r_C01.nr_sequencia);
		if (ie_simultaneo_w	= 'S') then
			--Caso seja válido, o sistema irá gerar uma string com todas as as regras válidas.
			if (nr_seq_regra_aux_w != r_C01.nr_sequencia) then

				nr_seq_regra_w	:= r_C01.nr_sequencia || ',' || nr_seq_regra_w;
			end if;
			nr_seq_regra_aux_w	:= r_C01.nr_sequencia;
		end if;
		end;
	end loop;
	
	end;
end loop;

ds_retorno_w	:= substr(nr_seq_regra_w,1,length(nr_seq_regra_w)-1);

return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_via_acesso_pck.pls_obtem_regra_via_acesso ( dados_conta_p pls_via_acesso_pck.dados_conta, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;