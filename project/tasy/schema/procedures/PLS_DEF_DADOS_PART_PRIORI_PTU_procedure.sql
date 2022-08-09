-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_def_dados_part_priori_ptu ( nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) is /*
	Essa rotina serve para definir quais os dados do participante principal do item, quando conta de origema500 e guia de spsadt. Nesses casos, com a nova versao
	do PTU(xml), agora o servico nao vem mais aberto, gerando apenas as informacoes de participacao na ptu_nova_servico, podendo entao agora ter muitlplos
	participantes, o que ocasionou na necessidade de criacao de uma nova tabela(ptu_nota_servico_equipe). Para resolver problemas que passaram a ocorrer 
	nas validacoes de item(duplicidade de item e utilizacao de item) , criamos campos na pls_conta_proc_regra que sao populados com as informacoes do 
	participante prioritario(definido de acordo com o grau de participacao do mesmo), com isso, nao se faz necessario obter o participante prioritario 
	durante a execucao das validacoes, o que ocasionaria em varias execucoes de uma mesma consulta
*/
 type dados_medico_partic is record ( sg_conselho ptu_nota_servico_equipe.sg_conselho%type, nr_conselho ptu_nota_servico_equipe.nr_conselho%type, uf_conselho ptu_nota_servico_equipe.uf_conselho%type, cd_prestador ptu_nota_servico_equipe.cd_prestador%type ) RETURNS DADOS_MEDICO_PARTIC AS $body$
DECLARE


ds_retorno_w	dados_medico_partic;
nr_seq_conta_w	pls_conta.nr_sequencia%type;
qt_registro_w	integer;
nr_seq_equipe_w	ptu_nota_servico_equipe.nr_sequencia%type;
BEGIN

ds_retorno_w.sg_conselho	:= null;
ds_retorno_w.nr_conselho	:= null;	
ds_retorno_w.uf_conselho	:= null;
ds_retorno_w.cd_prestador	:= null;

if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then


	-- Primeiramente sera feito um teste, para verificar se existe participantes no procedimento.
	-- Assim evitamos algumas trocas de contexto, buscando um prestadr que nao existe.
	-- Se esta rotina ficar pesada, para quem for otimizar, considerar a possibilidade de trocar as querys
	-- por uma so, ordenada com um decode pelo cd_tiss, e fazer um bulk collect. Nao fiz isto no momento
	-- pois agora me pareceu vantajoso fazer os if's, ao inves de usar o order by. Tem que levar em consideracao
	-- o padrao TISS, e as diversas formas que um prestador pode montar a conta.
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_equipe_w
	from	ptu_nota_servico_equipe	a
	where	a.nr_seq_nota_servico	= nr_seq_item_p;
	
	-- Se tiver algum participante, vai tentar buscar as inf dele
	if (nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '') then

		--Prioriza cirurgiao
		select	max(uf_conselho),
				max(sg_conselho),
				max(nr_conselho),
				max(cd_prestador)
		into STRICT	ds_retorno_w.uf_conselho,
				ds_retorno_w.sg_conselho,
				ds_retorno_w.nr_conselho,
				ds_retorno_w.cd_prestador
		from	ptu_nota_servico_equipe	a
		where	a.ie_tipo_participacao_tiss		= '00'
		and		a.nr_seq_nota_servico	= nr_seq_item_p  LIMIT 1;
		
		--Nao possuindo cirurgiao, busca por anestesista
		if ( coalesce(ds_retorno_w.uf_conselho::text, '') = '' and coalesce(ds_retorno_w.sg_conselho::text, '') = '' and
				coalesce(ds_retorno_w.nr_conselho::text, '') = '' and coalesce(ds_retorno_w.cd_prestador::text, '') = '') then

			select	max(uf_conselho),
					max(sg_conselho),
					max(nr_conselho),
					max(cd_prestador)
			into STRICT	ds_retorno_w.uf_conselho,
					ds_retorno_w.sg_conselho,
					ds_retorno_w.nr_conselho,
					ds_retorno_w.cd_prestador
			from	ptu_nota_servico_equipe	a
			where	a.ie_tipo_participacao_tiss		= '06'
			and		a.nr_seq_nota_servico	= nr_seq_item_p  LIMIT 1;

		end if;
		--Nao encontrando nem cirurgiao e anestessta, entao busca por primeiro auxiliar
		if ( coalesce(ds_retorno_w.uf_conselho::text, '') = '' and coalesce(ds_retorno_w.sg_conselho::text, '') = '' and
				coalesce(ds_retorno_w.nr_conselho::text, '') = '' and coalesce(ds_retorno_w.cd_prestador::text, '') = '') then
			
			select	max(uf_conselho),
					max(sg_conselho),
					max(nr_conselho),
					max(cd_prestador)
			into STRICT	ds_retorno_w.uf_conselho,
					ds_retorno_w.sg_conselho,
					ds_retorno_w.nr_conselho,
					ds_retorno_w.cd_prestador
			from	ptu_nota_servico_equipe	a
			where	a.ie_tipo_participacao_tiss		= '01'
			and		a.nr_seq_nota_servico	= nr_seq_item_p  LIMIT 1;
			
		end if;
		--nao encontrando tambem um primeiro auxiliar, busca pelo partic de maior sequencia
		if ( coalesce(ds_retorno_w.uf_conselho::text, '') = '' and coalesce(ds_retorno_w.sg_conselho::text, '') = '' and
				coalesce(ds_retorno_w.nr_conselho::text, '') = '' and coalesce(ds_retorno_w.cd_prestador::text, '') = '') then

			select	max(uf_conselho),
					max(sg_conselho),
					max(nr_conselho),
					max(cd_prestador)
			into STRICT	ds_retorno_w.uf_conselho,
					ds_retorno_w.sg_conselho,
					ds_retorno_w.nr_conselho,
					ds_retorno_w.cd_prestador	
			from	ptu_nota_servico_equipe	a
			where	a.nr_seq_nota_servico	= nr_seq_item_p
			and		a.nr_sequencia		= (	SELECT	max(x.nr_sequencia)
											from	ptu_nota_servico_equipe	x
											where	x.nr_seq_nota_servico	= nr_seq_item_p );

		end if;
	end if;
end if;

return ds_retorno_w;

end;		
		
begin

	for r_c01_w in C01 loop
		
			for r_c02_w in c02( r_c01_w.nr_seq_nota_cobranca, r_c01_w.nr_seq_proc) loop
			
				dados_medico_partic_busca := obter_dados_medico_exec( r_c02_w.nr_seq_item);
				
				if ( 	(dados_medico_partic_busca.sg_conselho IS NOT NULL AND dados_medico_partic_busca.sg_conselho::text <> '') or (dados_medico_partic_busca.nr_conselho IS NOT NULL AND dados_medico_partic_busca.nr_conselho::text <> '') or
						(dados_medico_partic_busca.uf_conselho IS NOT NULL AND dados_medico_partic_busca.uf_conselho::text <> '') or (dados_medico_partic_busca.cd_prestador IS NOT NULL AND dados_medico_partic_busca.cd_prestador::text <> '')) then
						
					update 	pls_conta_proc_regra
					set		sg_cons_prof_prest_nota_serv = dados_medico_partic_busca.sg_conselho,
                            nr_cons_prof_prest_nota_serv = dados_medico_partic_busca.nr_conselho,
                            sg_uf_cons_prest_nota_serv 	 = dados_medico_partic_busca.uf_conselho,
							cd_prest_eqp_nota_serv		 = dados_medico_partic_busca.cd_prestador
					where 	nr_sequencia = r_c01_w.nr_seq_proc;
					
				end if;			
			end loop;	
			
		end loop;	
commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_def_dados_part_priori_ptu ( nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) is  type dados_medico_partic is record ( sg_conselho ptu_nota_servico_equipe.sg_conselho%type, nr_conselho ptu_nota_servico_equipe.nr_conselho%type, uf_conselho ptu_nota_servico_equipe.uf_conselho%type, cd_prestador ptu_nota_servico_equipe.cd_prestador%type ) FROM PUBLIC;
