-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_processar_regra_audit_ptu ( nr_seq_lote_p pls_protocolo_conta.nr_seq_lote_conta%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


C00 CURSOR FOR
	SELECT  b.nr_seq_analise,
			pls_obter_cod_prestador(b.nr_seq_prestador_exec, null) cd_prestador,
			a.ie_origem_protocolo,
			(SELECT max(cd_pessoa_fisica) from pls_segurado where nr_sequencia = b.nr_seq_segurado) cd_pessoa_fisica,
			coalesce(b.cd_guia_referencia, b.cd_guia) cd_guia_principal,
			b.nr_sequencia nr_seq_conta,
			a.nr_sequencia nr_seq_protocolo
	from  	pls_protocolo_conta a,
			pls_conta b
	where  	a.nr_sequencia = b.nr_seq_protocolo
	and   	a.nr_seq_lote_conta = nr_seq_lote_p
	order by nr_seq_analise;

C01 CURSOR(  ie_origem_protocolo_pc   pls_protocolo_conta.ie_origem_protocolo%type,
			cd_prestador_exec_pc  pls_prestador.cd_prestador%type) FOR
  SELECT  	ie_alimenta_ptu,
			nr_seq_etapa
  from  pls_regra_ali_audit_ptu
  where (ie_origem_protocolo =  ie_origem_protocolo_pc or coalesce(ie_origem_protocolo::text, '') = '')
  and (cd_prestador = cd_prestador_exec_pc or coalesce(cd_prestador::text, '') = '');

nr_seq_analise_anterior_w  	pls_analise_conta.nr_sequencia%type := -1;
ie_alimenta_ptu_w      		pls_regra_ali_audit_ptu.ie_alimenta_ptu%type;
nr_interno_conta_w      	conta_paciente.nr_interno_conta%type;
nr_seq_etapa_w        		pls_regra_ali_audit_ptu.nr_seq_etapa%type;
cd_pf_conta_pac_etapa_w    	conta_paciente_etapa.cd_pessoa_fisica%type;
sg_conselho_w        		conselho_profissional.sg_conselho%type;
nr_seq_membro_grupo_aud_w  	pls_membro_grupo_aud.nr_sequencia%type;
nr_log_contador_w		integer;
ds_log_call_w			varchar(1500);
ds_observacao_w			varchar(4000);

procedure insere_conta_auditor(  nr_seq_analise_p       pls_analise_conta.nr_sequencia%type,
								nr_seq_membro_grupo_aud_p  pls_membro_grupo_aud.nr_sequencia%type,
								ie_tipo_conselho_p      text,
								nm_usuario_p        usuario.nm_usuario%type) is

C01 CURSOR FOR
  SELECT  	a.nr_sequencia,
			a.nr_seq_analise
  from  	pls_conta a
  where  	a.nr_seq_analise = nr_seq_analise_p
  and (    SELECT   count(1)
		    from   pls_conta_auditor x
		    where  x.nr_seq_conta = a.nr_sequencia
		    and x.nr_seq_grupo_membro_enf = nr_seq_membro_grupo_aud_p
		    and ie_tipo_conselho_p = 'COREN') = 0
  and (  select count(1)
		from	pls_conta_auditor x
		where  	x.nr_seq_conta = a.nr_sequencia
		and    	x.nr_seq_grupo_membro_med = nr_seq_membro_grupo_aud_p
		and    	ie_tipo_conselho_p = 'CRM') = 0;

BEGIN

  for r_c01_w in c01 loop

    insert into pls_conta_auditor(nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
                    nr_seq_grupo_membro_med, nr_seq_grupo_membro_enf, nr_seq_analise)
    values (  nextval('pls_conta_auditor_seq'), clock_timestamp(), nm_usuario_p,
        clock_timestamp(), nm_usuario_p, r_c01_w.nr_sequencia,
        CASE WHEN ie_tipo_conselho_p='CRM' THEN  nr_seq_membro_grupo_aud_p  ELSE null END , CASE WHEN ie_tipo_conselho_p='COREN' THEN  nr_seq_membro_grupo_aud_p  ELSE null END ,
        r_c01_w.nr_seq_analise);

  end loop;

end;

begin

  for r_c00_w in C00 loop
	
	select	count(1)
	into STRICT	nr_log_contador_w	
	from	pls_regra_ali_audit_ptu
	where	ie_alimenta_ptu	= 'S';
	
	if (nr_log_contador_w > 0) then		

		ds_log_call_w := substr(pls_obter_detalhe_exec(false),1,1500);
		ds_observacao_w :=	'Analise: '||r_c00_w.nr_seq_analise||chr(13)||chr(10)||
					'Prestador: '||r_c00_w.cd_prestador||chr(13)||chr(10)||
					'Pessoa fisica: '||r_c00_w.cd_pessoa_fisica||chr(13)||chr(10)||
					'Origem protocolo: '||r_c00_w.ie_origem_protocolo||chr(13)||chr(10)||
					'Guia principal: '||r_c00_w.cd_guia_principal;
		
		insert into plsprco_cta(	nr_sequencia, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela,
						ds_log, ds_log_call, ds_funcao_ativa,
						ie_aplicacao_tasy, nm_maquina, nr_seq_protocolo,
						nr_seq_conta, ie_opcao )
				values (	nextval('plsprco_cta_seq'), clock_timestamp(), substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado '),1,14),
						clock_timestamp(), substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado '),1,14), 'PLS_REGRA_ALI_AUDIT_PTU',
						ds_observacao_w, ds_log_call_w, obter_funcao_ativa,
						pls_se_aplicacao_tasy, wheb_usuario_pck.get_machine, r_c00_w.nr_seq_protocolo, 
						r_c00_w.nr_seq_conta, '0');
	end if;
	
	

    ie_alimenta_ptu_w := null;
	nr_seq_etapa_w := null;
	
	select  max(ie_alimenta_ptu) ie_alimenta_ptu,
			max( nr_seq_etapa ) nr_seq_etapa
	into STRICT	ie_alimenta_ptu_w,
			nr_seq_etapa_w
  	from  	pls_regra_ali_audit_ptu
  	where ( ie_origem_protocolo =  r_c00_w.ie_origem_protocolo or coalesce(ie_origem_protocolo::text, '') = '')
  	and ( cd_prestador = r_c00_w.cd_prestador or coalesce(cd_prestador::text, '') = '')
	and 	ie_alimenta_ptu = 'S';


    --Se tiver uma regra determinando que deve alimentar o auditor PTU, ent?o identifica se h? auditoria na conta paciente.
    if (ie_alimenta_ptu_w = 'S') then

		select   max(c.nr_interno_conta)
		into STRICT  nr_interno_conta_w
		from   tiss_conta_guia g,
			conta_paciente c,
			atendimento_paciente a
		where   g.nr_interno_conta = c.nr_interno_conta
		and     c.nr_atendimento = a.nr_atendimento
		and     a.cd_pessoa_fisica = r_c00_w.cd_pessoa_fisica
		and (g.cd_autorizacao = r_c00_w.cd_guia_principal
			or g.cd_autorizacao_princ = r_c00_w.cd_guia_principal );

      --Com base no atendimento encontrado, busco se existe uma finaliza??o de auditoria
        if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then

            select  max(cd_pessoa_fisica)
            into STRICT cd_pf_conta_pac_etapa_w
            from  conta_paciente_etapa a
            where  a.nr_interno_conta = nr_interno_conta_w
            and   a.nr_seq_etapa = nr_seq_etapa_w;

            if (cd_pf_conta_pac_etapa_w IS NOT NULL AND cd_pf_conta_pac_etapa_w::text <> '') then
            
		    	select   max(b.sg_conselho)
		    	into STRICT  	sg_conselho_w
		    	from  	pessoa_fisica a,
		    			conselho_profissional b
		    	where  	a.nr_seq_conselho = b.nr_sequencia
		    	and   	a.cd_pessoa_fisica = cd_pf_conta_pac_etapa_w;

		    	if (sg_conselho_w = 'CRM') then
            
		    		select   max(a.nr_sequencia)
		    		into STRICT  	nr_seq_membro_grupo_aud_w
		    		from   	pls_membro_grupo_aud a,
							usuario b
		    		where   a.nm_usuario_exec = b.nm_usuario
					and 	b.cd_pessoa_fisica = cd_pf_conta_pac_etapa_w
					and 	a.ie_situacao = 'A'
					and 	a.ie_auditor_ptu = 'S';
					
																					
		    		insere_conta_auditor(r_c00_w.nr_seq_analise, nr_seq_membro_grupo_aud_w, 'CRM', nm_usuario_p );
	
				elsif (sg_conselho_w = 'COREN') then
		
					select  max(a.nr_sequencia)
					into STRICT  	nr_seq_membro_grupo_aud_w	
					from   	pls_membro_grupo_aud a,
							usuario b							
					where   a.nm_usuario_exec = b.nm_usuario
					and 	b.cd_pessoa_fisica = cd_pf_conta_pac_etapa_w
					and 	a.ie_situacao = 'A'
					and 	a.ie_auditor_ptu = 'S';
	
		    		insere_conta_auditor(r_c00_w.nr_seq_analise, nr_seq_membro_grupo_aud_w, 'COREN', nm_usuario_p );

		    	end if;

            end if;
        end if;
    end if;

  end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_processar_regra_audit_ptu ( nr_seq_lote_p pls_protocolo_conta.nr_seq_lote_conta%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
