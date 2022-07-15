-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cf_gerar_pendencia_guia (nr_interno_conta_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text, ds_complemento_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_interno_conta_w   conta_paciente.nr_interno_conta%type;
nr_atendimento_w    conta_paciente.nr_atendimento%type;
nr_seq_status_mob_w		conta_paciente.nr_seq_status_mob%type;
cd_setor_atendimento_w atend_paciente_unidade.cd_setor_atendimento%type;
nr_seq_estagio_w    cta_estagio_pend.nr_sequencia%type;
ie_pendencia_w			cf_regra_estagio.ie_pendencia%type;
ds_status_fat_w			cf_status_faturamento.ds_status_fat%type;
nr_seq_status_fat_w		conta_paciente.nr_seq_status_fat%type;
nr_seq_regra_fluxo_w	conta_paciente.nr_seq_regra_fluxo%type;
ds_classificacao_w		cta_regra_resp_pend.ds_regra%type;
dt_pendencia_w     timestamp;
nr_seq_regra_resp_w   bigint;
nr_seq_regra_item_w   bigint;
nr_seq_pendencia_w   bigint;
ds_tipo_pend_w			cta_tipo_pend.ds_tipo%type;


BEGIN 
 
 
if (coalesce(nr_interno_conta_p,0) <> 0) then 
 
 
 
    select max(nr_interno_conta), 
        max(nr_atendimento), 
        max(obter_setor_atendimento(nr_atendimento)), 
				max(nr_seq_regra_fluxo), 
				max(nr_seq_status_fat) 
    into STRICT  nr_interno_conta_w, 
        nr_atendimento_w, 
        cd_setor_atendimento_w, 
				nr_seq_regra_fluxo_w, 
				nr_seq_status_fat_w 
    from  conta_paciente 
    where  nr_interno_conta = nr_interno_conta_p;
		 
		select 	max(ds_tipo) 
		into STRICT	ds_tipo_pend_w 
		from 	cta_tipo_pend 
		where 	nr_sequencia = nr_seq_tipo_p;
 
    select min(nr_sequencia) 
    into STRICT  nr_seq_estagio_w 
    from  cta_estagio_pend 
    where  coalesce(ie_situacao,'A') = 'A' 
    and   ie_tipo_estagio = 'A' 
    and	 cta_obter_se_estagio_lib(nr_sequencia, obter_perfil_ativo, nm_usuario_p, nr_seq_tipo_p) = 'S';
 
    dt_pendencia_w := clock_timestamp();
 
    SELECT * FROM cta_obter_regra_resp_pend(nr_seq_tipo_p, nr_seq_estagio_w, dt_pendencia_w, nr_seq_regra_resp_w, nr_seq_regra_item_w) INTO STRICT nr_seq_regra_resp_w, nr_seq_regra_item_w;
		 
 
    if (coalesce(nr_seq_regra_resp_w,0) <> 0) then 
 
        select nextval('cta_pendencia_seq') 
        into STRICT  nr_seq_pendencia_w 
;
 
        insert into cta_pendencia( 
            nr_sequencia, 
            nr_atendimento, 
            dt_atualizacao, 
            nm_usuario, 
            dt_atualizacao_nrec, 
            nm_usuario_nrec, 
            dt_pendencia, 
            nr_seq_tipo, 
            nr_seq_estagio, 
            nr_interno_conta, 
            cd_setor_atendimento, 
            nr_seq_regra_resp, 
						ds_complemento 
        ) values ( 
            nr_seq_pendencia_w, 
            nr_atendimento_w, 
            clock_timestamp(), 
            nm_usuario_p, 
            clock_timestamp(), 
            nm_usuario_p, 
            dt_pendencia_w, 
            nr_seq_tipo_p, 
            nr_seq_estagio_w, 
            nr_interno_conta_w, 
            cd_setor_atendimento_w, 
            nr_seq_regra_resp_w, 
						ds_complemento_p 
        );
				 
				 
			select	max(ie_pendencia) 
			into STRICT	ie_pendencia_w 
			from	cf_regra_estagio 
			where	nr_seq_regra = nr_Seq_regra_fluxo_w 
			and		nr_seq_status_fat = nr_seq_status_fat_w;			
		 
 		  if (ie_pendencia_w IS NOT NULL AND ie_pendencia_w::text <> '') then 
			 
				if (ie_pendencia_w = 'F') then 
						nr_seq_status_mob_w := cf_obter_status_mob(nr_seq_status_fat_w, 'P');
				elsif (ie_pendencia_w = 'R') then 
						nr_seq_status_mob_w := cf_obter_status_mob(nr_seq_status_fat_w, 'B');
				end if;
			 
				select	max(nr_sequencia) 
				into STRICT	nr_seq_status_fat_w 
				from	cf_status_faturamento 
				where	ie_pendencia = ie_pendencia_w 
				and		ie_situacao = 'A';
				 
				--buscar ds_status_fat 
				select	max(ds_status_fat) 
				into STRICT	ds_status_fat_w 
				from	cf_status_faturamento 
				where	nr_sequencia = nr_seq_status_fat_w;				
				 
				update	conta_paciente 
				set		nr_seq_status_fat = nr_seq_status_fat_w, 
						nr_seq_status_mob = coalesce(nr_seq_status_mob_w, nr_seq_status_mob), 
						nm_usuario = nm_usuario_p 
				where	nr_interno_conta = nr_interno_conta_p;
				 
				select	max(ds_regra) 
				into STRICT	ds_classificacao_w 
				from	cta_regra_resp_pend 
				where	nr_sequencia = nr_seq_regra_resp_w;
				 
				delete from w_cf_consulta_guia	 
				where	nm_usuario = nm_usuario_p 
				and		nr_interno_conta = nr_interno_conta_p;
			 
			end if;
	 
 
    else 
        ds_erro_p    := WHEB_MENSAGEM_PCK.get_texto(281189) || ds_tipo_pend_w || WHEB_MENSAGEM_PCK.get_texto(281190);
    end if;
 
 
end if;
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cf_gerar_pendencia_guia (nr_interno_conta_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text, ds_complemento_p text, ds_erro_p INOUT text) FROM PUBLIC;

