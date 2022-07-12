-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_acao_ocor_comb_req ( nr_seq_requisicao_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar as ocorrências do cabeçalho e dos procedimentos cadastrados na requisição e enviar a
requisição para auditoria caso tiver sido gerado algumas ocorrência combinada específica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*
ie_opcao_p
V = Verificar
O = Obter a ação.
*/
ds_retorno_w			varchar(1)	:= 'N';
nr_seq_ocorrencia_w		bigint;
ie_aplicacao_regra_w		varchar(3);
ie_gerar_auditoria_w		varchar(1);
ie_retorno_w			varchar(1);
nr_seq_proc_w			bigint;
nr_seq_mat_w			bigint;
ie_carater_internacao_w    	varchar(2);

C01 CURSOR FOR
	SELECT  nr_seq_ocorrencia
	from  pls_ocorrencia_benef
	where  nr_seq_requisicao  = nr_seq_requisicao_p;

C03 CURSOR FOR
	SELECT  a.nr_seq_ocorrencia
	from  	pls_ocorrencia_benef a
	where  	a.nr_seq_proc  = nr_seq_proc_p
	and	coalesce(a.nr_seq_glosa_req::text, '') = '';

C05 CURSOR FOR
	SELECT  a.nr_seq_ocorrencia
	from  	pls_ocorrencia_benef a
	where  	a.nr_seq_mat  = nr_seq_mat_p
	and	coalesce(a.nr_seq_glosa_req::text, '') = '';



BEGIN
/*
open C01;
loop
fetch C01 into
	nr_seq_ocorrencia_w;
exit when C01%notfound;
begin
	begin
		select   ie_aplicacao_regra
		into  ie_aplicacao_regra_w
		from  pls_ocor_aut_combinada
		where  nr_seq_ocorrencia  = nr_seq_ocorrencia_w;
	exception
	when others then
		ie_aplicacao_regra_w := 0;
	end;

	if  (ie_opcao_p  = 'V') then
		if  ie_aplicacao_regra_w in (18,19) then
			ie_retorno_w  := 'S';
			exit;
		end if;
	elsif  (ie_opcao_p  = 'O') then
		if  ie_aplicacao_regra_w in (18,19) then
			ie_gerar_auditoria_w  := 'A';
			exit;
		end if;
	end if;
	end;
end loop;
close C01;
*/
open C03;
loop
fetch C03 into
	nr_seq_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
		begin
			select  ie_aplicacao_regra
			into STRICT  	ie_aplicacao_regra_w
			from  	pls_ocor_aut_combinada
			where  	nr_seq_ocorrencia  = nr_seq_ocorrencia_w;
		exception
		when others then
			ie_aplicacao_regra_w := 0;
		end;


		if (ie_opcao_p  = 'V') then
		/* Validação das ocorrências nos procedimentos da guia */

			if (ie_aplicacao_regra_w  = 16) then
				ie_retorno_w  := 'S';
				exit;
			end if;
		elsif (ie_opcao_p  = 'O') then
			if (ie_aplicacao_regra_w = 16) then
				select  IE_CARATER_ATENDIMENTO
				into STRICT  ie_carater_internacao_w
				from  pls_requisicao
				where   nr_sequencia  = nr_seq_requisicao_p;

				if (ie_carater_internacao_w  = 'U') then
					ie_gerar_auditoria_w  := 'S';
					CALL pls_define_status_itens_req(nr_seq_proc_w, 'A', null, null, null);
				end if;
				exit;
			end if;
		end if;
	end;
end loop;
close C03;

open C05;
loop
fetch C05 into
	nr_seq_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	begin
		begin
			select  ie_aplicacao_regra
			into STRICT  	ie_aplicacao_regra_w
			from  	pls_ocor_aut_combinada
			where  	nr_seq_ocorrencia  = nr_seq_ocorrencia_w;
		exception
		when others then
			ie_aplicacao_regra_w := 0;
		end;

		if (ie_opcao_p  = 'V') then
		/* Validação das ocorrências nos materiais da guia */

			if (ie_aplicacao_regra_w = 16) then
				ie_retorno_w  := 'S';
				exit;
			end if;
		elsif (ie_opcao_p  = 'O') then
			if (ie_aplicacao_regra_w = 16) then
				select  IE_CARATER_ATENDIMENTO
				into STRICT  	ie_carater_internacao_w
				from  	pls_requisicao
				where   nr_sequencia  = nr_seq_requisicao_p;

				if (ie_carater_internacao_w  = 'U') then
					ie_gerar_auditoria_w  := 'S';
					CALL pls_define_status_itens_req(null, 'A', nr_seq_mat_w, null, null);
				end if;
				exit;
			end if;
		end if;
	end;
end loop;
close C05;

if (ie_opcao_p  = 'V') then
	ds_retorno_w  := ie_retorno_w;
elsif (ie_opcao_p  = 'O') then
	ds_retorno_w  := ie_gerar_auditoria_w;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_acao_ocor_comb_req ( nr_seq_requisicao_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, ie_opcao_p text) FROM PUBLIC;

