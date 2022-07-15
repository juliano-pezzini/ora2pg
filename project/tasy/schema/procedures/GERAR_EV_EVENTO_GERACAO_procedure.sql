-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ev_evento_geracao ( nm_usuario_p text) AS $body$
DECLARE


ie_forma_ev_w    varchar(15);
ie_pessoa_destino_w  varchar(15);
cd_pf_destino_w    varchar(10);
ds_mensagem_w    varchar(4000);
ds_titulo_w    varchar(100);
cd_pessoa_destino_w  varchar(10);
nr_sequencia_w    bigint;
ds_maquina_w    varchar(80);
nm_paciente_w    varchar(60);
ds_unidade_w    varchar(60);
ds_setor_atendimento_w  varchar(60);
ie_usuario_aceite_w  varchar(1);
qt_corresp_w    integer;
cd_setor_atendimento_w  integer;
cd_perfil_w    integer;
cd_pessoa_regra_w  varchar(20);
nr_ramal_w    varchar(10);
nr_telefone_w    varchar(40);
cd_convenio_w    bigint;
nr_seq_evento_w    bigint;
ie_existe_evento_w    varchar(1);
nr_atendimento_w    bigint;
cd_setor_atend_w    integer;
dt_entrada_unidade_w  timestamp;
dt_saida_unidade_w  timestamp;
dt_saida_unidade_must_w	 timestamp;
cd_pessoa_fisica_w  varchar(10);
ie_existe_inf_w    varchar(1) := 'S';
nr_seq_regra_w    bigint;
ie_regra_geracao_w  varchar(15);
nr_seq_tipo_avaliacao_w  bigint;
qt_hora_w    bigint;
qt_horas_w    bigint;
qt_horas_internados_w  bigint;
qt_minuto_w    bigint;
cd_setor_atend_ev_w  integer;
dt_liberacao_apache_w  timestamp;
dt_liberacao_prescr_w  timestamp;
dt_avaliacao_pac_w  timestamp;
dt_evento_gerado_w  timestamp;
dt_liberacao_w     timestamp;
dt_liberacao_ww     timestamp;
sql_err_w      varchar(2000);
nm_usuario_destino_w  varchar(15);
cd_setor_atend_pac_w  integer;
dt_entrada_w    timestamp;
qt_must_w    bigint;
qt_must_ww    bigint;
nr_atendimento_anterior_w	bigint;
nr_atendimento_anterior_ww	bigint;
qt_total_aval_w			bigint;
dt_avaliacao_ww timestamp;
dt_lib_w		timestamp;
nm_medico_responsavel_w pessoa_fisica.nm_pessoa_fisica%type;
nm_usuario_w pessoa_fisica.nm_pessoa_fisica%type;

C01 CURSOR FOR
  SELECT   /*+ INDEX(B ATEPACU_I1) INDEX(a atepaci_pk) */    a.cd_pessoa_fisica,
    b.cd_setor_atendimento,
    a.nr_atendimento,
    b.dt_entrada_unidade,
    b.dt_saida_unidade,
    a.dt_entrada
  FROM  atendimento_paciente a,
    atend_paciente_unidade b,
    unidade_atendimento c
  WHERE  a.nr_atendimento = b.nr_atendimento
  AND  c.CD_SETOR_ATENDIMENTO = b.CD_SETOR_ATENDIMENTO
  AND  c.CD_UNIDADE_BASICA    = b.CD_UNIDADE_BASICA  
  AND  c.CD_UNIDADE_COMPL     = b.CD_UNIDADE_COMPL  
  AND  a.nr_atendimento = c.nr_atendimento
  AND  b.dt_entrada_unidade < clock_timestamp()
  AND  coalesce(a.dt_alta::text, '') = ''
  order by a.nr_atendimento;

C02 CURSOR FOR
  SELECT  nr_sequencia,
    coalesce(ds_titulo,''),
    coalesce(ds_mensagem,'')
  from  ev_evento
  where  ie_tipo_acao = 'J'
  order by  ds_titulo;

C03 CURSOR FOR
  SELECT  ie_forma_ev,
    coalesce(ie_pessoa_destino,''),
    coalesce(cd_pf_destino,''),
    coalesce(ie_usuario_aceite,'N'),
    cd_setor_atendimento,
    cd_perfil
  from  ev_evento_regra_dest
  where  coalesce(cd_convenio, coalesce(cd_convenio_w,0))  = coalesce(cd_convenio_w,0)
  and  coalesce(cd_setor_atend_pac, coalesce(cd_setor_atend_pac_w,0))  = coalesce(cd_setor_atend_pac_w,0)  
  and  nr_seq_evento = nr_seq_evento_w
  order by  ie_forma_ev;

C04 CURSOR FOR
  SELECT  distinct
      obter_dados_usuario_opcao(nm_usuario,'C')
  from  usuario_setor_v
  where  cd_setor_atendimento = cd_setor_atendimento_w
  and  ie_forma_ev_w in (2,3)
  and  (obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '')
  and  obter_dados_usuario_opcao(nm_usuario, 'T') = 'A';

C05 CURSOR FOR
  SELECT  distinct
      obter_dados_usuario_opcao(nm_usuario,'C'),
      nm_usuario
  from  usuario_perfil
  where  cd_perfil = cd_perfil_w
  and  ie_forma_ev_w in (2,3)
  and  (obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '')
  and  obter_dados_usuario_opcao(nm_usuario, 'T') = 'A';

C06 CURSOR FOR
  SELECT  nr_sequencia,
    ie_regra_geracao,
    nr_seq_tipo_avaliacao,
    coalesce(qt_hora,0),
    coalesce(qt_minuto,0),
    cd_setor_atendimento
  from  ev_evento_geracao
  where  nr_seq_evento = nr_seq_evento_w;


BEGIN

begin

open C01;
loop
fetch C01 into
  cd_pessoa_fisica_w,
  cd_setor_atend_w,
  nr_atendimento_w,
  dt_entrada_unidade_w,
  dt_saida_unidade_w,
  dt_entrada_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
  begin
  ie_regra_geracao_w  := '';
  ie_existe_inf_w    := 'S';

  ie_existe_evento_w := 'N';

  open C02;
  loop
  fetch C02 into
    nr_seq_evento_w,
    ds_titulo_w,
    ds_mensagem_w;
  EXIT WHEN NOT FOUND; /* apply on C02 */
    begin

      open C06;
      loop
      fetch C06 into
        nr_seq_regra_w,
        ie_regra_geracao_w,
        nr_seq_tipo_avaliacao_w,
        qt_hora_w,
        qt_minuto_w,
        cd_setor_atend_ev_w;
      EXIT WHEN NOT FOUND; /* apply on C06 */
        begin
        ie_existe_inf_w := 'S';

        if (ie_regra_geracao_w in ('SAH','SPH','SBH','SSH','SSD')) then
          select  max(b.dt_evento)
          into STRICT  dt_evento_gerado_w
          from  ev_evento_pac_destino a,
            ev_evento_paciente b
          where  a.nr_seq_ev_pac = b.nr_sequencia
          and  b.nr_seq_evento = nr_seq_evento_w
          and  b.nr_atendimento = nr_atendimento_w
          and  a.ie_status = 'G';
        else
          select  coalesce(max('S'),'N')
          into STRICT  ie_existe_evento_w
          from  ev_evento_pac_destino a,
            ev_evento_paciente b
          where  a.nr_seq_ev_pac = b.nr_sequencia
          and  b.nr_seq_evento = nr_seq_evento_w
          and  b.nr_atendimento = nr_atendimento_w;
        end if;

        if (ie_existe_evento_w = 'N') or (ie_regra_geracao_w in ('SAH','SPH','MUST24h','MUST','SAP2','SBH','SSH','NRS','SSD','NRS2')) then

          if (ie_regra_geracao_w = 'SRG') then
            
            select  trunc(clock_timestamp(),'hh') - trunc(dt_entrada,'hh')
            into STRICT  qt_horas_internados_w
            from  atendimento_paciente
            where  nr_atendimento = nr_atendimento_w;

            if  (qt_horas_internados_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then
              ie_existe_inf_w := 'N';
            end if;
            
          elsif (ie_regra_geracao_w = 'SA') and (coalesce(dt_saida_unidade_w::text, '') = '') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) then
              qt_horas_w := (clock_timestamp() - dt_entrada_unidade_w) * 24;
              if (qt_horas_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then
                select  coalesce(max('S'),'N')
                into STRICT  ie_existe_inf_w
                from  apache
                where  nr_atendimento = nr_atendimento_w;
              end if;
            end if;

          elsif (ie_regra_geracao_w = 'SAH') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
              select  max(dt_liberacao)
              into STRICT  dt_liberacao_apache_w
              from  apache
              where  nr_atendimento = nr_atendimento_w
              and  (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

              if ((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and ( coalesce(dt_liberacao_apache_w::text, '') = '') and ( dt_liberacao_apache_w > dt_entrada_unidade_w)) or
                ((coalesce(dt_evento_gerado_w::text, '') = '') and
                 (( coalesce(dt_liberacao_apache_w::text, '') = '') or ( dt_liberacao_apache_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
                ie_existe_inf_w := 'N';
              end if;

            end if;
		  elsif (ie_regra_geracao_w = 'SBH') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
              select  max(dt_liberacao)
              into STRICT  dt_liberacao_apache_w
              from  atend_escala_braden
              where  nr_atendimento = nr_atendimento_w
              and  (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

              if ((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and ( coalesce(dt_liberacao_apache_w::text, '') = '') and ( dt_liberacao_apache_w > dt_entrada_unidade_w)) or
                ((coalesce(dt_evento_gerado_w::text, '') = '') and
                 (( coalesce(dt_liberacao_apache_w::text, '') = '') or ( dt_liberacao_apache_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
                ie_existe_inf_w := 'N';
              end if;

            end if;
		  elsif (ie_regra_geracao_w = 'SSH') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
              select  max(dt_liberacao)
              into STRICT  dt_liberacao_apache_w
              from  escala_stratify
              where  nr_atendimento = nr_atendimento_w
              and  (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

              if ((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and ( coalesce(dt_liberacao_apache_w::text, '') = '') and ( dt_liberacao_apache_w > dt_entrada_unidade_w)) or
                ((coalesce(dt_evento_gerado_w::text, '') = '') and
                 (( coalesce(dt_liberacao_apache_w::text, '') = '') or ( dt_liberacao_apache_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
                ie_existe_inf_w := 'N';
              end if;

            end if;
		 elsif (ie_regra_geracao_w = 'SSD') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
              select  max(dt_liberacao)
              into STRICT  dt_liberacao_apache_w
              from  aval_nutric_subjetiva
              where  nr_atendimento = nr_atendimento_w
			  and coalesce(ie_tipo_avaliacao,'D') = 'D'
              and  (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

              if ((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and ( coalesce(dt_liberacao_apache_w::text, '') = '') and ( dt_liberacao_apache_w > dt_entrada_unidade_w)) or
                ((coalesce(dt_evento_gerado_w::text, '') = '') and
                 (( coalesce(dt_liberacao_apache_w::text, '') = '') or ( dt_liberacao_apache_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
                ie_existe_inf_w := 'N';
              end if;

            end if;
          elsif (ie_regra_geracao_w = 'SPH') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
              select  max(dt_liberacao)
              into STRICT  dt_liberacao_prescr_w
              from  prescr_medica
              where  nr_atendimento = nr_atendimento_w
              and  (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

              if ((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and (coalesce(dt_liberacao_prescr_w::text, '') = '') and (dt_liberacao_prescr_w > dt_entrada_unidade_w)) or
                ((coalesce(dt_evento_gerado_w::text, '') = '') and
                 ((coalesce(dt_liberacao_prescr_w::text, '') = '') or (dt_liberacao_prescr_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
                ie_existe_inf_w := 'N';
              end if;

            end if;
		  elsif (ie_regra_geracao_w = 'NRS') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
				
				select	max(dt_liberacao)
				into STRICT	dt_lib_w
				from	escala_nrs
				where	nr_atendimento = nr_atendimento_w
				and		ie_situacao = 'A'
				and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			
				if (dt_lib_w IS NOT NULL AND dt_lib_w::text <> '') then
					if 	((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and ( coalesce(dt_lib_w::text, '') = '') and ( dt_lib_w > dt_entrada_unidade_w)) or
						((coalesce(dt_evento_gerado_w::text, '') = '') and
						(( coalesce(dt_lib_w::text, '') = '') or ( dt_lib_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
							ie_existe_inf_w := 'N';
					end if;
				end if;
            end if;
		  elsif (ie_regra_geracao_w = 'NRS2') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
				
				select	max(dt_liberacao)
				into STRICT	dt_lib_w
				from	escala_nrs
				where	nr_atendimento = nr_atendimento_w
				and		ie_situacao = 'A'
				and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
				and		qt_pontuacao <= 2
				and		nr_sequencia = (SELECT max(x.nr_sequencia)
										from	escala_nrs x
										where	nr_atendimento = nr_atendimento_w
										and		ie_situacao = 'A'
										and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));
			
				if (dt_lib_w IS NOT NULL AND dt_lib_w::text <> '') then
					if 	((dt_saida_unidade_w IS NOT NULL AND dt_saida_unidade_w::text <> '') and ( coalesce(dt_lib_w::text, '') = '') and ( dt_lib_w > dt_entrada_unidade_w)) or
						((coalesce(dt_evento_gerado_w::text, '') = '') and
						(( coalesce(dt_lib_w::text, '') = '') or ( dt_lib_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))) then
							ie_existe_inf_w := 'N';
					end if;
				end if;
            end if;
          elsif (ie_regra_geracao_w = 'SAP') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) then
              qt_horas_w := (clock_timestamp() - dt_entrada_unidade_w) * 24;
              if (qt_horas_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then
                select  coalesce(max('S'),'N')
                into STRICT  ie_existe_inf_w
                from  med_avaliacao_paciente
                where  nr_atendimento = nr_atendimento_w
                and (nr_seq_tipo_avaliacao = nr_seq_tipo_avaliacao_w or coalesce(nr_seq_tipo_avaliacao_w::text, '') = '');
              end if;
            end if;
	  elsif (ie_regra_geracao_w = 'SAP2') then
            --if  (cd_setor_atend_w = cd_setor_atend_ev_w) or (cd_setor_atend_ev_w is null) then
		select  count(*),
			to_date(MAX(coalesce(dt_liberacao,dt_avaliacao)),'dd/mm/yyy hh24:mi:ss')
		into STRICT 	qt_total_aval_w,
			dt_avaliacao_ww
		from 	med_avaliacao_paciente a
		where 	a.cd_pessoa_fisica =  cd_pessoa_fisica_w
                and     nr_seq_tipo_avaliacao = nr_seq_tipo_avaliacao_w
                and (SELECT count(*)
                     from   atendimento_paciente b
                     where  b.cd_pessoa_fisica = a.cd_pessoa_fisica ) > 1;

		if (qt_total_aval_w > 0) THEN	
			qt_horas_w := (clock_timestamp() - dt_avaliacao_ww) * 24;

			if (qt_horas_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then					
				ie_existe_inf_w := 'N';			
			end if;
		end if;
           --end if; 
	   
          elsif (ie_regra_geracao_w = 'SASS') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) then
              select  coalesce(max(dt_avaliacao),clock_timestamp() - interval '9999 days')
              into STRICT  dt_avaliacao_pac_w
              from  med_avaliacao_paciente
              where  nr_atendimento = nr_atendimento_w
              and (nr_seq_tipo_avaliacao = nr_seq_tipo_avaliacao_w or coalesce(nr_seq_tipo_avaliacao_w::text, '') = '');

              if (dt_saida_unidade_w > dt_avaliacao_pac_w) then
                ie_existe_inf_w := 'N';
              end if;
            end if;
            
          elsif (ie_regra_geracao_w = 'SD') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
              qt_horas_w := (clock_timestamp() - dt_entrada_unidade_w) * 24;
              if (qt_horas_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then
                select  coalesce(max('S'),'N')
                into STRICT  ie_existe_inf_w
                from  diagnostico_doenca
                where  nr_atendimento = nr_atendimento_w;
              end if;
            end if;
          elsif (ie_regra_geracao_w = 'MUST') then
                
            if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
		SELECT  distinct b.dt_saida_unidade
		into STRICT	dt_saida_unidade_must_w
		FROM    atendimento_paciente a, 
			atend_paciente_unidade b
		WHERE   a.nr_atendimento = b.nr_atendimento
		and     a.nr_atendimento = nr_atendimento_w
		AND     coalesce(a.dt_alta::text, '') = ''
		and    	coalesce(b.dt_saida_unidade::text, '') = '';
		
		select  max(a.dt_liberacao)
		into STRICT   	dt_liberacao_w
		from   	escala_must a
		where  	a.nr_sequencia = (	SELECT   max(b.nr_sequencia)
						from     escala_must b
						where    b.nr_atendimento = nr_atendimento_w
						and      coalesce(b.dt_inativacao::text, '') = ''
						and	 coalesce(dt_saida_unidade_must_w::text, '') = ''
						and      (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''));
		
		select  max(dt_entrada)
		into STRICT   	dt_liberacao_ww
		from   	atendimento_paciente a
		where  	coalesce(dt_liberacao_w::text, '') = ''
		and	a.nr_atendimento = nr_atendimento_w;
		
              if   	((dt_liberacao_w <(clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))) or
			(dt_liberacao_ww <(clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))))and
			substr(obter_dados_Pf(cd_pessoa_fisica_w,'I'),1,255) >= 12 and
			((nr_atendimento_anterior_w <> nr_atendimento_w) or (coalesce(nr_atendimento_anterior_w::text, '') = '')) and (dt_saida_unidade_must_w is  null) then
			ie_existe_inf_w  :=  'N';
              end if;
	
	      nr_atendimento_anterior_w	:= nr_atendimento_w;
	
            end if;
          elsif (ie_regra_geracao_w = 'MUST24h') then
            
	    if (cd_setor_atend_w = cd_setor_atend_ev_w) or (coalesce(cd_setor_atend_ev_w::text, '') = '') then
		
		SELECT  distinct b.dt_saida_unidade
		into STRICT	dt_saida_unidade_must_w
		FROM    atendimento_paciente a, 
			atend_paciente_unidade b
		WHERE   a.nr_atendimento = b.nr_atendimento
		and     a.nr_atendimento = nr_atendimento_w
		AND     coalesce(a.dt_alta::text, '') = ''
		and    	coalesce(b.dt_saida_unidade::text, '') = '';
		
		select  	count(*)
		into STRICT    	qt_must_w
		from    	escala_must y
		where   	y.nr_atendimento = nr_atendimento_w
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	 	coalesce(dt_saida_unidade_w::text, '') = '';
		
		select  	count(*)
		into STRICT    	qt_must_ww
		from    	escala_must y
		where   	y.nr_atendimento = nr_atendimento_w
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

              if   	(dt_entrada_w < (clock_timestamp() - (coalesce(qt_hora_w + (qt_minuto_w/60),0) / 24))) and (qt_must_w = '0') and (qt_must_ww = 0) and (substr(obter_dados_Pf(cd_pessoa_fisica_w,'I'),1,255) >= 12) and
			((nr_atendimento_anterior_ww <> nr_atendimento_w) or (coalesce(nr_atendimento_anterior_ww::text, '') = '')) and (coalesce(dt_saida_unidade_must_w::text, '') = '') 	then
                ie_existe_inf_w  := 'N';
              end if;
	
	      nr_atendimento_anterior_ww   := nr_atendimento_w;
	
            end if;
          elsif (ie_regra_geracao_w = 'CRIB') and (coalesce(dt_saida_unidade_w::text, '') = '') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) then
              qt_horas_w := (clock_timestamp() - dt_entrada_unidade_w) * 24;
              if (qt_horas_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then
                select  coalesce(max('S'),'N')
                into STRICT  ie_existe_inf_w
                from  escala_crib
                where  nr_atendimento = nr_atendimento_w;
              end if;
            end if;
          elsif (ie_regra_geracao_w = 'NAS') and (coalesce(dt_saida_unidade_w::text, '') = '') then
            if (cd_setor_atend_w = cd_setor_atend_ev_w) then
              qt_horas_w := (clock_timestamp() - dt_entrada_unidade_w) * 24;
              if (qt_horas_w >= coalesce(qt_hora_w + (qt_minuto_w/60),0)) then
                select  coalesce(max('S'),'N')
                into STRICT  ie_existe_inf_w
                from  escala_nas
                where  nr_atendimento = nr_atendimento_w;
              end if;
            end if;

          end if;

          if (ie_existe_inf_w = 'N') then

            /*select  substr(obter_inf_sessao(0)||' - ' || obter_inf_sessao(1),1,80)
            into  ds_maquina_w
            from  dual;*/
            ds_maquina_w := '';
            
            select  coalesce(max(obter_convenio_atendimento(nr_atendimento_w)), 0)
            into STRICT  cd_convenio_w
;

            select	substr(max(ds_usuario),1,40)
            into STRICT	nm_usuario_w
            from	usuario
            where	nm_usuario = nm_usuario_p;

            select  substr(obter_nome_pf(cd_pessoa_fisica_w),1,60),
                substr(obter_unidade_atendimento(nr_atendimento_w,'A','U'),1,60),
                substr(obter_unidade_atendimento(nr_atendimento_w,'A','RA'),1,60),
                substr(obter_unidade_atendimento(nr_atendimento_w,'A','TL'),1,60),
                substr(obter_unidade_atendimento(nr_atendimento_w,'A','S'),1,60),
                substr(obter_unidade_atendimento(nr_atendimento_w,'A','CS'),1,60)
            into STRICT  nm_paciente_w,
                ds_unidade_w,
                nr_ramal_w,
                nr_telefone_w,
                ds_setor_atendimento_w,
                cd_setor_atend_pac_w
;

            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@quarto',ds_unidade_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@setor',ds_setor_atendimento_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@atendimento',nr_atendimento_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@ramal',nr_ramal_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@telefone',nr_telefone_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@nomeusuario',nm_usuario_w),1,4000);
            ds_mensagem_w  := substr(replace_macro(ds_mensagem_w,'@med_resp',obter_medico_resp_atend(nr_atendimento_w, 'N')),1,4000);

            select  nextval('ev_evento_paciente_seq')
            into STRICT  nr_sequencia_w
;

            insert into ev_evento_paciente(
              nr_sequencia,
              nr_seq_evento,
              dt_atualizacao,
              nm_usuario,
              dt_atualizacao_nrec,
              nm_usuario_nrec,
              cd_pessoa_fisica,
              nr_atendimento,
              ds_titulo,
              ds_mensagem,
              ie_status,
              ds_maquina,
              dt_evento,
              dt_liberacao,
              ie_situacao)
            values (  nr_sequencia_w,
              nr_seq_evento_w,
              clock_timestamp(),
              nm_usuario_p,
              clock_timestamp(),
              nm_usuario_p,
              cd_pessoa_fisica_w,
              nr_atendimento_w,
              ds_titulo_w,
              ds_mensagem_w,
              'G',
              ds_maquina_w,
              clock_timestamp(),
              clock_timestamp(),
              'A');

              commit;
              
            open C03;
            loop
            fetch C03 into
              ie_forma_ev_w,
              ie_pessoa_destino_w,
              cd_pf_destino_w,
              ie_usuario_aceite_w,
              cd_setor_atendimento_w,
              cd_perfil_w;
            EXIT WHEN NOT FOUND; /* apply on C03 */
              begin
              qt_corresp_w  := 1;
              cd_pessoa_destino_w := null;

              if (ie_pessoa_destino_w = '1') then /* Medico do atendimento */
                begin
                select  max(cd_medico_atendimento)
                into STRICT  cd_pessoa_destino_w
                from  atendimento_paciente
                where  nr_atendimento  = nr_atendimento_w;
                end;
              elsif (ie_pessoa_destino_w = '2') then /*Medico responsevel pelo paciente*/
                begin
                select  max(cd_medico_resp)
                into STRICT  cd_pessoa_destino_w
                from  atendimento_paciente
                where  nr_atendimento  = nr_atendimento_w;
                end;
              elsif (ie_pessoa_destino_w = '4') then /*Medico referido*/
                begin
                select  max(cd_medico_referido)
                into STRICT  cd_pessoa_destino_w
                from  atendimento_paciente
                where  nr_atendimento  = nr_atendimento_w;
                end;
              elsif (ie_pessoa_destino_w = '5') or (ie_pessoa_destino_w = '12') then /*Pessoa fixa ou Usuario fixo*/
                cd_pessoa_destino_w  := cd_pf_destino_w;
              end if;

              if (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '1') then  /*ie_forma_ev 1 = SMS / 2 = Tela / 3 = Comunicacao Interna / 4 = E-mail*/
                begin
                select  count(*)
                into STRICT  qt_corresp_w
                from  pessoa_fisica_corresp
                where  cd_pessoa_fisica  = cd_pessoa_destino_w
                and  ie_tipo_corresp    = 'MCel'
                and  ie_tipo_doc    = 'AE';
                end;
              elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '3') then
                begin
                select  count(*)
                into STRICT  qt_corresp_w
                from  pessoa_fisica_corresp
                where  cd_pessoa_fisica  = cd_pessoa_destino_w
                and  ie_tipo_corresp    = 'CI'
                and  ie_tipo_doc    = 'AE';
                end;
              elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '4') then
                begin
                select  count(*)
                into STRICT  qt_corresp_w
                from  pessoa_fisica_corresp
                where  cd_pessoa_fisica  = cd_pessoa_destino_w
                and  ie_tipo_corresp    = 'Email'
                and  ie_tipo_doc    = 'AE';
                end;
              end if;

              if (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (qt_corresp_w > 0) then
                begin

                insert into ev_evento_pac_destino(
                  nr_sequencia,
                  nr_seq_ev_pac,
                  dt_atualizacao,
                  nm_usuario,
                  dt_atualizacao_nrec,
                  nm_usuario_nrec,
                  cd_pessoa_fisica,
                  ie_forma_ev,
                  ie_status,
                  dt_ciencia,
                  ie_pessoa_destino,
		  dt_evento)
                values (  nextval('ev_evento_pac_destino_seq'),
                  nr_sequencia_w,
                  clock_timestamp(),
                  nm_usuario_p,
                  clock_timestamp(),
                  nm_usuario_p,
                  cd_pessoa_destino_w,
                  ie_forma_ev_w,
                  'G',
                  null,
                  ie_pessoa_destino_w,
		  clock_timestamp());
                end;
              end if;

              
              open C04;
              loop
              fetch C04 into
                cd_pessoa_regra_w;
              EXIT WHEN NOT FOUND; /* apply on C04 */
                begin
                /*Setor de atendimento*/

                if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then
                  insert into ev_evento_pac_destino(
                    nr_sequencia,
                    nr_seq_ev_pac,
                    dt_atualizacao,
                    nm_usuario,
                    dt_atualizacao_nrec,
                    nm_usuario_nrec,
                    cd_pessoa_fisica,
                    ie_forma_ev,
                    ie_status,
                    dt_ciencia,
                    ie_pessoa_destino,
		    dt_evento)
                  values (
                    nextval('ev_evento_pac_destino_seq'),
                    nr_sequencia_w,
                    clock_timestamp(),
                    nm_usuario_p,
                    clock_timestamp(),
                    nm_usuario_p,
                    cd_pessoa_regra_w,
                    ie_forma_ev_w,
                    'G',
                    null,
                    ie_pessoa_destino_w,
		    clock_timestamp());
                end if;
                end;
              end loop;
              close C04;

              open C05;
              loop
              fetch C05 into
                cd_pessoa_regra_w,
                nm_usuario_destino_w;
              EXIT WHEN NOT FOUND; /* apply on C05 */
                begin
                /*Perfil*/

                if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then
                  insert into ev_evento_pac_destino(
                    nr_sequencia,
                    nr_seq_ev_pac,
                    dt_atualizacao,
                    nm_usuario,
                    dt_atualizacao_nrec,
                    nm_usuario_nrec,
                    cd_pessoa_fisica,
                    ie_forma_ev,
                    ie_status,
                    dt_ciencia,
                    nm_usuario_dest,
                    ie_pessoa_destino,
		    dt_evento)
                  values (  nextval('ev_evento_pac_destino_seq'),
                    nr_sequencia_w,
                    clock_timestamp(),
                    nm_usuario_p,
                    clock_timestamp(),
                    nm_usuario_p,
                    cd_pessoa_regra_w,
                    ie_forma_ev_w,
                    'G',
                    null,
                    nm_usuario_destino_w,
                    ie_pessoa_destino_w,
		    clock_timestamp());
                  end if;
              end;
              end loop;
              close C05;

              
              end;
              end loop;
              close C03;

            end if;
          end if;
          end;
        end loop;
        close C06;
      --end if;  
    end;
  end loop;
  close C02;

end;
end loop;
close C01;

commit;

exception
when others then
  sql_err_w     := substr(SQLERRM, 1, 1800);
  --insert into log_xxxtasy values (sysdate, nm_usuario_p, -50, sql_err_w);
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ev_evento_geracao ( nm_usuario_p text) FROM PUBLIC;

