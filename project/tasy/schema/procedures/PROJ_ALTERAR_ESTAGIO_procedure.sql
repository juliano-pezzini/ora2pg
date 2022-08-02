-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_alterar_estagio ( nr_seq_projeto_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_p
	A - anterior
	P - proximo
*/
nr_seq_apres_w			bigint;
nr_seq_apres_ww			bigint;
ie_status_w				varchar(3);
nr_seq_estagio_w		bigint;
nr_sequencia_w			bigint;
qt_requisitos_w			smallint;
base_corp_w				varchar(1);
pr_realizacao_w			proj_cronograma.pr_realizacao%type;
ie_origem_w				proj_projeto.ie_origem%type;
nr_seq_classif_w		proj_projeto.NR_SEQ_CLASSIF%type;
cd_metodologia_w		proj_projeto.CD_METODOLOGIA%type;
qt_risco_w				bigint;
ds_historico_w			varchar(4000);
qt_historico_w			bigint;

c01 CURSOR(nr_seq_estagio_cp bigint) FOR
SELECT		a.ds_tipo_historico,
			a.nr_sequencia
from		com_tipo_historico a,
			proj_classif_historico b
where		a.nr_sequencia = b.nr_seq_tipo_historico
and			b.nr_seq_estagio = nr_seq_estagio_cp
and			b.nr_seq_classif = nr_seq_classif_w
and (b.cd_metodologia = cd_metodologia_w or coalesce(b.cd_metodologia::text, '') = '')
and			b.ie_situacao <> 'I'
order by 	b.nr_seq_apres;


BEGIN

select	max(b.nr_seq_apres),
		max(nr_seq_estagio),
		max(a.NR_SEQ_CLASSIF),
		max(a.cd_metodologia)
into STRICT	nr_seq_apres_w,
		nr_seq_estagio_w,
		nr_seq_classif_w,
		cd_metodologia_w
from	proj_estagio	b,
		proj_projeto	a
where	a.nr_sequencia 		= nr_seq_projeto_p
and		a.nr_seq_estagio	= b.nr_sequencia
and 	a.ie_origem 		= 'D';

--Definição da sequência anterior do estágio
if (ie_opcao_p	= 'A') then
	select	max(nr_seq_apres)
	into STRICT	nr_seq_apres_ww
	from	proj_estagio
	where	nr_seq_apres <> nr_seq_apres_w
	and	ie_origem 	 = 'D'
	and	nr_seq_apres	< nr_seq_apres_w;
	
--Definição da próxima sequência do estágio	
elsif (ie_opcao_p	= 'P') then
	select	min(nr_seq_apres)
	into STRICT	nr_seq_apres_ww
	from	proj_estagio
	where	nr_seq_apres <> nr_seq_apres_w
	and	ie_origem 	 = 'D'
	and	nr_seq_apres  > nr_seq_apres_w;
	
end if;

if (coalesce(nr_seq_apres_ww,0) > 0) then
-- Carrega as informações do estágio definido
	select	ie_status,
			nr_sequencia
	into STRICT	ie_status_w,
			nr_sequencia_w
	from	proj_estagio
	where	nr_seq_apres	= nr_seq_apres_ww;

	--verifica se é base corp
	select	obter_se_base_corp
	into STRICT	base_corp_w
	;
	

	if (ie_status_w in ('T','F') and base_corp_w = 'S') then
		--verifica se há requisititos não atendidos ou parcialmente atendidos
		select	count(b.nr_sequencia)
		into STRICT	qt_requisitos_w
		from	des_requisito a,
				des_requisito_item b
		where	a.nr_sequencia = b.nr_seq_requisito
		and		b.ie_status in ('N','P')
		and		a.nr_seq_projeto = nr_seq_projeto_p  LIMIT 1;

		if (qt_requisitos_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(284141); /*Não é permitido este Status para projeto sem atender à todos os requisitos.*/
		end if;
		
		select	count(*)
		into STRICT	qt_risco_w
		from	proj_risco_implantacao
		where	nr_seq_proj = nr_seq_projeto_p
		and		coalesce(DT_FIM_REAL::text, '') = '';

		if (qt_risco_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort('There are pending risks for closure');
		end if;
						
		if (ie_opcao_p	= 'P') then
			select	max(pr_realizacao)
			into STRICT	pr_realizacao_w
			from	proj_cronograma
			where	nr_seq_proj = nr_seq_projeto_p;
			
			if ((pr_realizacao_w IS NOT NULL AND pr_realizacao_w::text <> '') and pr_realizacao_w <> 100) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort('There are pending activities in the project schedule');
			end if;
		
		end if;

	end if;
	
	
	--Verifica os históricos obrigatórios da etapa 
	
	for r_c01_w in c01(nr_seq_estagio_w) loop
		
		select 	count(1)
		into STRICT	qt_historico_w
		from	COM_CLIENTE_HIST
		where	nr_seq_projeto = nr_seq_projeto_p
		and		nr_seq_tipo = r_c01_w.nr_sequencia
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
		
		if (qt_historico_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort('Pending evidence: (History) '||r_c01_w.ds_tipo_historico);
		end if;		
	end loop;
	
	update	proj_projeto
	set	nr_seq_estagio	= nr_sequencia_w,
		ie_status	= ie_status_w,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia 	= nr_seq_projeto_p;
	
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_alterar_estagio ( nr_seq_projeto_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

