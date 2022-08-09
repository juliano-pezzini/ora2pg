-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_sinal_vital (nr_sequencia_p bigint, nm_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


  nr_atendimento_w              atendimento_sinal_vital.nr_atendimento%type;
  ie_atualiza_altura_sv_pf_w    parametro_medico.ie_atualiza_altura_sv_pf%type;
  ie_atualiza_peso_sv_pf_w      parametro_medico.ie_atualiza_peso_sv_pf%type;
  qt_altura_cm_w                atendimento_sinal_vital.qt_altura_cm%type;
  qt_peso_w                     atendimento_sinal_vital.qt_peso%type;
  cd_pessoa_fisica_w            pessoa_fisica.cd_pessoa_fisica%type;
  nr_regras_atendidas_w         varchar(2000);
  nr_seq_agenda_w				        atendimento_sinal_vital.nr_seq_agendamento%type;
  nr_tipo_agenda_w			        atendimento_sinal_vital.nr_tipo_agenda%type;


BEGIN

if (upper(nm_tabela_p) = 'ATENDIMENTO_SINAL_VITAL') then
	begin

    update	atendimento_sinal_vital
    set dt_liberacao 	= clock_timestamp(),
        nm_usuario	    = nm_usuario_p,
        dt_atualizacao	= clock_timestamp()
    where nr_sequencia	= nr_sequencia_p;

    select	max(nr_atendimento),
            max(qt_altura_cm),
            max(qt_peso),
            max(nr_seq_agendamento),
            max(nr_tipo_agenda)
    into STRICT	nr_atendimento_w,
          qt_altura_cm_w,
          qt_peso_w,
          nr_seq_agenda_w,
          nr_tipo_agenda_w
    from	atendimento_sinal_vital
    where	nr_sequencia	= nr_sequencia_p;

    select	max(ie_atualiza_altura_sv_pf),
            max(ie_atualiza_peso_sv_pf)
    into STRICT	ie_atualiza_altura_sv_pf_w,
          ie_atualiza_peso_sv_pf_w
    from	parametro_medico
    where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

    cd_pessoa_fisica_w := substr(obter_pessoa_atendimento(nr_atendimento_w,'C'),1,10);

    if (ie_atualiza_altura_sv_pf_w = 'S' and coalesce(qt_altura_cm_w,0) > 0) then
      update	pessoa_fisica
      set	    qt_altura_cm = qt_altura_cm_w
      where	cd_pessoa_fisica = cd_pessoa_fisica_w;
    end if;

    if (ie_atualiza_peso_sv_pf_w = 'S' and coalesce(qt_peso_w,0) > 0) then
      update	pessoa_fisica
      set	    qt_peso = qt_peso_w
      where	cd_pessoa_fisica = cd_pessoa_fisica_w;
    end if;

    if (coalesce(nr_atendimento_w, 0) > 0) then
        CALL gerar_reaprazar_sae_regra_sv(nr_sequencia_p, nm_usuario_p);
        CALL gerar_lanc_automatico_tabela(nr_atendimento_w,412,upper(nm_tabela_p),nr_sequencia_p,nm_usuario_p);
        CALL executar_evento_agenda_atend(nr_atendimento_w,'LSV',obter_estab_atend(nr_atendimento_w),nm_usuario_p,null,null,nr_seq_agenda_w,nr_tipo_agenda_w);
        begin
            nr_regras_atendidas_w := GQA_Liberacao_Sinal_Vital(nr_sequencia_p, nm_usuario_p);
            CALL gera_protocolo_assistencial(nr_atendimento_w, nm_usuario_p);
        exception
        when others then
            null;
        end;
    end if;
	
	end;
elsif (upper(nm_tabela_p) = 'ATENDIMENTO_MONIT_RESP') then
	begin
	
	update atendimento_monit_resp
	set dt_liberacao = clock_timestamp(),
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_sequencia_p;

	CALL gerar_pend_atend_monit_resp(nr_sequencia_p,
    nm_usuario_p );

	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_monit_resp
	where	nr_sequencia	= nr_sequencia_p;
	
	CALL gerar_lanc_automatico_tabela(nr_atendimento_w,401,upper(nm_tabela_p),nr_sequencia_p,nm_usuario_p);
	CALL executar_evento_agenda_atend(nr_atendimento_w,'LSV',obter_estab_atend(nr_atendimento_w),nm_usuario_p,null);
	end;
elsif (upper(nm_tabela_p) = 'ATEND_MONIT_HEMOD') then
	begin
	Update	atend_monit_hemod
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario	    = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atend_monit_hemod
	where	nr_sequencia	= nr_sequencia_p;
	
	CALL gerar_lanc_automatico_tabela(nr_atendimento_w,431,upper(nm_tabela_p),nr_sequencia_p,nm_usuario_p);
	CALL executar_evento_agenda_atend(nr_atendimento_w,'LSV',obter_estab_atend(nr_atendimento_w),nm_usuario_p,null);
	
	end;
elsif (upper(nm_tabela_p) = 'ATEND_AVAL_ANALGESIA') then
	begin
	Update	atend_aval_analgesia
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario      = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	end;
elsif (upper(nm_tabela_p) = 'ATEND_ANAL_BIOQ_PORT') then
	begin
	Update	atend_anal_bioq_port
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario	    = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	end;
elsif (upper(nm_tabela_p) = 'ATEND_UROANALISE') then
	begin
	Update	atend_uroanalise
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario	    = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atend_uroanalise
	where	nr_sequencia = nr_sequencia_p;
	
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,572,nm_usuario_p,nr_sequencia_p,null,null,null,null,null);
	
	end;
elsif (upper(nm_tabela_p) = 'ATEND_UROCOLOR') then
	begin
	Update	ATEND_UROCOLOR
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario	    = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	ATEND_UROCOLOR
	where	nr_sequencia = nr_sequencia_p;
	
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,572,nm_usuario_p,nr_sequencia_p,null,null,null,null,null);
	
	end;	
elsif (upper(nm_tabela_p) = 'ATEND_BIOIMPEDANCIA') then
	begin
	Update	ATEND_BIOIMPEDANCIA
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario	    = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	ATEND_BIOIMPEDANCIA
	where	nr_sequencia	= nr_sequencia_p;
	
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,534,nm_usuario_p,nr_sequencia_p,null,null,null,null,null);
	
	end;	
elsif (upper(nm_tabela_p) = 'ATEND_URO_CHOICE') then
	begin
	Update	ATEND_URO_CHOICE
	set 	dt_liberacao 	= clock_timestamp(),
            nm_usuario	    = nm_usuario_p,
            dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia	= nr_sequencia_p;
	
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	ATEND_URO_CHOICE
	where	nr_sequencia	= nr_sequencia_p;
	
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,572,nm_usuario_p,nr_sequencia_p,null,null,null,null,null);
	
	end;
elsif (upper(nm_tabela_p) = 'PEP_AUTOR_ACESSO') then
	begin
	update	PEP_AUTOR_ACESSO
	set	dt_liberacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
	end;
elsif (upper(nm_tabela_p) = 'PEP_AUTOR_ACESSO_ATEND') then
	begin
    update	PEP_AUTOR_ACESSO_ATEND
    set	dt_liberacao = clock_timestamp(),
      nm_usuario = nm_usuario_p,
      dt_atualizacao = clock_timestamp()
    where	nr_sequencia = nr_sequencia_p;
	end;
elsif (upper(nm_tabela_p) = 'CIRCULACAO_EXTRACORPOREA') then
	begin
    update	CIRCULACAO_EXTRACORPOREA
    set		dt_liberacao = clock_timestamp(),
        nm_usuario = nm_usuario_p,
        dt_atualizacao = clock_timestamp()
    where 	nr_sequencia = nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_sinal_vital (nr_sequencia_p bigint, nm_tabela_p text, nm_usuario_p text) FROM PUBLIC;
