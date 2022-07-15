-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (		nm_sinal_vital	varchar(100),
				vl_sinal_vital	varchar(100),
				ds_unidade_medida	varchar(100),
				ds_lista		varchar(255));


CREATE OR REPLACE PROCEDURE gerar_sinal_vital_drager ( cd_pessoa_fisica_p text, dt_sinal_vital_p text, ds_lista_parametros_p text, nm_usuario_p text) AS $body$
DECLARE

type Vetor is table of campos index 	by integer;
Vetor_w			Vetor;



nr_atendimento_w	bigint;
dt_sinal_vital_w	timestamp;
nr_seq_sinal_vital_w	bigint	:= 0;
ds_sep_w		varchar(100)	:= ';';
nr_pos_separador_w	bigint;
qt_parametros_w		bigint;
qt_contador_w		bigint;
ds_parametros_w		varchar(4000);
i			integer;
ds_lista_aux_w		varchar(255);
ds_sep_bv_w		varchar(30)	:= obter_separador_bv;
nr_seq_monit_resp_w	bigint	:= 0;
nr_seq_monit_hemo_w	bigint	:= 0;
ds_erro_w		varchar(4000);
nr_cirurgia_w	bigint := null;
nr_seq_pepo_w	bigint := null;
qt_reg_w		bigint;
dt_alta_w		timestamp;
ie_monitorado_w	varchar(2);
nls_numeric_characters_w    varchar(255);
cd_conversao_w	conversao_meio_externo.cd_externo%type;
cd_conversao_invasiva_w	conversao_meio_externo.cd_externo%type;
ie_invasivo_w varchar(2) := 'N';


	procedure inserir_sv is
	;
BEGIN
	if (nr_seq_sinal_vital_w	= 0) then

		select	nextval('atendimento_sinal_vital_seq')
		into STRICT	nr_seq_sinal_vital_w
		;

		insert into atendimento_sinal_vital(	nr_sequencia,
							nr_atendimento,
							dt_sinal_vital,
							dt_atualizacao,
							nm_usuario,
							CD_PESSOA_FISICA,
							dt_liberacao,
							ie_situacao,
							nr_cirurgia,
							nr_seq_pepo,
							ie_integracao)
				values (	nr_seq_sinal_vital_w,
							nr_atendimento_w,
							dt_sinal_vital_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							clock_timestamp(),
							'A',
							nr_cirurgia_w,
							nr_seq_pepo_w,
							'S');
	end if;
	end;

	procedure inserir_resp is
	begin
	if (nr_seq_monit_resp_w	= 0) then

		select	nextval('atendimento_monit_resp_seq')
		into STRICT	nr_seq_monit_resp_w
		;

		insert into ATENDIMENTO_MONIT_RESP(	nr_sequencia,
							nr_atendimento,
							DT_MONITORIZACAO,
							dt_atualizacao,
							nm_usuario,
							CD_PESSOA_FISICA,
							dt_liberacao,
							ie_situacao,
							nr_cirurgia,
							nr_seq_pepo)
				values (	nr_seq_monit_resp_w,
							nr_atendimento_w,
							dt_sinal_vital_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							clock_timestamp(),
							'A',
							nr_cirurgia_w,
							nr_seq_pepo_w);
	end if;
	end;

	
	procedure inserir_hemo is
	begin
	if (nr_seq_monit_hemo_w	= 0) then

		select	nextval('atend_monit_hemod_seq')
		into STRICT	nr_seq_monit_hemo_w
		;

		insert into ATEND_MONIT_HEMOD(	nr_sequencia,
							nr_atendimento,
							DT_MONITORACAO,
							dt_atualizacao,
							nm_usuario,
							CD_PESSOA_FISICA,
							dt_liberacao,
							ie_situacao,
							nr_cirurgia,
							nr_seq_pepo)
				values (	nr_seq_monit_hemo_w,
							nr_atendimento_w,
							dt_sinal_vital_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							clock_timestamp(),
							'A',
							nr_cirurgia_w,
							nr_seq_pepo_w);
	end if;
	end;	
	

	procedure atualizar_valor_sv(	nm_tabela_p	varchar2,
					nm_atributo_p	varchar2,
					vl_parametro_p	varchar2) is
	ds_comando_w	varchar2(2000);
	ds_parametros_w	varchar2(2000);
	vl_parametro_w	varchar2(2000);
	begin
	
	vl_parametro_w	:= vl_parametro_p;
	if (nls_numeric_characters_w <> '.,') and -- Avoing issues with customer outside Brasil
    ((substr(nm_atributo_p,1,2) = 'QT') or (substr(nm_atributo_p,1,2) = 'PR') or (substr(nm_atributo_p,1,2) = 'VL') or (substr(nm_atributo_p,1,2) = 'TX')) then
    vl_parametro_w := replace(vl_parametro_w,'.',',');
    end if;
	
	
	begin
	
	ds_comando_w	:= 	'	update	'||nm_tabela_p	||
				'	set	'||nm_atributo_p||' = :vl_parametro'||
				'	where	nr_sequencia	= :nr_sequencia ';

	if (nm_tabela_p	= 'ATENDIMENTO_SINAL_VITAL') and (vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') and (lower(vl_parametro_p)	<> 'null') and ((trim(both vl_parametro_p) IS NOT NULL AND (trim(both vl_parametro_p))::text <> '')) then
		inserir_sv;
		ds_parametros_w:=	'vl_parametro='||vl_parametro_w||ds_sep_bv_w||
					'nr_sequencia='||nr_seq_sinal_vital_w||ds_sep_bv_w;

		CALL Exec_sql_Dinamico_bv(nm_usuario_p,ds_comando_w,ds_parametros_w);
	elsif (nm_tabela_p	= 'ATENDIMENTO_MONIT_RESP') and (vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') and (lower(vl_parametro_p)	<> 'null') and ((trim(both vl_parametro_p) IS NOT NULL AND (trim(both vl_parametro_p))::text <> '')) 	then
		
		inserir_resp;
		
		
		ds_parametros_w:=	'vl_parametro='||vl_parametro_w||ds_sep_bv_w||
					'nr_sequencia='||nr_seq_monit_resp_w||ds_sep_bv_w;

					
		CALL Exec_sql_Dinamico_bv(nm_usuario_p,ds_comando_w,ds_parametros_w);
	elsif (nm_tabela_p	= 'ATEND_MONIT_HEMOD')  and (vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') and (lower(vl_parametro_p)	<> 'null') and ((trim(both vl_parametro_p) IS NOT NULL AND (trim(both vl_parametro_p))::text <> '')) then
		inserir_hemo;
		ds_parametros_w:=	'vl_parametro='||vl_parametro_w||ds_sep_bv_w||
					'nr_sequencia='||nr_seq_monit_hemo_w||ds_sep_bv_w;

		CALL Exec_sql_Dinamico_bv(nm_usuario_p,ds_comando_w,ds_parametros_w);
	end if;

	exception
		when others then
			ds_erro_w		:= substr(sqlerrm(SQLSTATE),1,4000);
		null;
	end;
	
	end;
begin

begin
dt_sinal_vital_w := to_date(dt_sinal_vital_p, 'yyyymmddhh24miss');
exception
	when others then
	dt_sinal_vital_w	:= clock_timestamp();
end;
/*
select 	max(nr_atendimento)
into 	nr_atendimento_w
from 	atendimento_paciente
where 	cd_pessoa_fisica  = cd_pessoa_fisica_p;
*/
begin
select max(value)
into STRICT nls_numeric_characters_w
from v$nls_parameters
where parameter = 'NLS_NUMERIC_CHARACTERS';
exception
when others then
nls_numeric_characters_w := null;
end;
nr_atendimento_w	:= cd_pessoa_fisica_p;


if	(dt_sinal_vital_w	< (clock_timestamp() -(1/24/2))) or
	((dt_sinal_vital_w	> (clock_timestamp() +(1/24/2))))then
	-- Nao e possivel gerar um sinal vital com data maior ou menor a 30 minutos.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264638);
end if;


select	max(nr_cirurgia),
		max(nr_seq_pepo)
into STRICT	nr_cirurgia_w,
		nr_seq_pepo_w
from	cirurgia
where	nr_atendimento = nr_atendimento_w
and		dt_sinal_vital_w between dt_inicio_real and coalesce(dt_termino, dt_sinal_vital_w);

if (coalesce(nr_cirurgia_w, 0) = 0) then
  select	max(nr_sequencia)
  into STRICT	nr_seq_pepo_w
  from	pepo_cirurgia
  where	nr_atendimento = nr_atendimento_w
  and		dt_sinal_vital_w between dt_inicio_proced and coalesce(dt_fim_cirurgia, dt_sinal_vital_w)
  and ie_tipo_procedimento = 'F';
end if;

ds_parametros_w    := ds_lista_parametros_p;
i	:= 0;
ds_parametros_w	   := replace(ds_parametros_w,'null','');


while(length(ds_parametros_w) > 0) loop
	begin
	i	:= i+1;
	if (position(';' in ds_parametros_w)	>0)  then
		Vetor_w[i].ds_lista	:= substr(ds_parametros_w,1,position(';' in ds_parametros_w)-1 );
		ds_parametros_w	:= substr(ds_parametros_w,position(';' in ds_parametros_w)+1,40000);

	else
		Vetor_w[i].ds_lista	:=substr(ds_parametros_w,1,length(ds_parametros_w) - 1);
		ds_parametros_w	:= null;
	end if;

	end;
end loop;


select	count(*)
into STRICT	qt_reg_w
from	atendimento_sinal_vital
where	nr_atendimento	= nr_atendimento_w
and		dt_sinal_vital	= dt_sinal_vital_w;

select 	max(dt_alta)
into STRICT	dt_alta_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w;

select	Obter_se_leito_atual_monit(nr_atendimento_w)
into STRICT	ie_monitorado_w
;

if (ie_monitorado_w = 'N') then

    select	coalesce(max('S'),'N')
    into STRICT	ie_monitorado_w	
    from	atend_paciente_unidade a,
            unidade_atendimento b
    where	a.nr_atendimento = nr_atendimento_w
    and		a.cd_setor_atendimento = b.cd_setor_atendimento
    and		a.cd_unidade_basica = b.cd_unidade_basica
    and		coalesce(b.ie_leito_monitorado,'N') = 'S'
    and		coalesce(b.IE_MONITORIZACAO_EXTERNA,'N') = 'S'
    and		dt_sinal_vital_w >= a.dt_entrada_unidade;

end if;


if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (qt_reg_w	= 0) and (coalesce(dt_alta_w::text, '') = '')	and (ie_monitorado_w = 'S')then
	for j in 1..Vetor_w.count loop
		begin

		ds_lista_aux_w	:= Vetor_w[j].ds_lista;

		Vetor_w[j].nm_sinal_vital	:= substr(ds_lista_aux_w,1,position('#@#@' in ds_lista_aux_w)-1 );
		ds_lista_aux_w	:= substr(ds_lista_aux_w,position('#@#@' in ds_lista_aux_w)+4,40000);
		Vetor_w[j].ds_unidade_medida	:= substr(ds_lista_aux_w,1,position('#@#@' in ds_lista_aux_w)- 1 );
		ds_lista_aux_w	:= substr(ds_lista_aux_w,position('#@#@' in ds_lista_aux_w)+4,40000);

        if (nm_usuario_p = 'Drager - TIE') then
            ds_lista_aux_w	:= substr(ds_lista_aux_w,position('#@#@' in ds_lista_aux_w)+4,40000);
        end if;
    Vetor_w[j].vl_sinal_vital	:= substr(ds_lista_aux_w,1,4000 );

		end;
	end loop;


	for i in 1..Vetor_w.count loop
		begin

    if (Vetor_w[i].nm_sinal_vital	= 'NBP' and ie_invasivo_w = 'N') then
      ie_invasivo_w := 'X';
    end if;
		if (Vetor_w[i].nm_sinal_vital	= 'FC') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARDIACA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_FC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'RESP' or  Vetor_w[i].nm_sinal_vital	= 'mib RR' or  Vetor_w[i].nm_sinal_vital	= 'RR*' or  Vetor_w[i].nm_sinal_vital	= 'RR') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_RESP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'ART D' or Vetor_w[i].nm_sinal_vital	= 'P1 D') then
			ie_invasivo_w := 'S';
      atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_DIASTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_DIAST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'ART S' or Vetor_w[i].nm_sinal_vital	= 'P1 S') then
			ie_invasivo_w := 'S';
      atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_SISTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_SIST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'ART M' or Vetor_w[i].nm_sinal_vital	= 'P1 M') then
			ie_invasivo_w := 'S';
      atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PAM',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PAM',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'ICP') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PRESSAO_INTRA_CRANIO',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'PPC') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PPC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'T') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'Ta'  or Vetor_w[i].nm_sinal_vital	= 'T1') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'PEF' or Vetor_w[i].nm_sinal_vital	= 'mib PEEP' or Vetor_w[i].nm_sinal_vital	= 'PEEP') then
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_PEEP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'FiO2') then
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_FIO2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'SaO2' or Vetor_w[i].nm_sinal_vital	= 'mib SaO2' or Vetor_w[i].nm_sinal_vital	= 'SaO2*' or Vetor_w[i].nm_sinal_vital	= 'SpO2*') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SATURACAO_O2',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_SATURACAO_O2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'SvO2' or Vetor_w[i].nm_sinal_vital	= 'mib SvO2') then
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_SAT_VENOSA_O2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'PPC') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PRESSAO_INTRA_CRANIO',Vetor_w[i].vl_sinal_vital);
			
		elsif (Vetor_w[i].nm_sinal_vital = 'PVC' or Vetor_w[i].nm_sinal_vital = 'CVP'
                or Vetor_w[i].nm_sinal_vital = 'PVCs') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PVC',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PVC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'Ti*') or (Vetor_w[i].nm_sinal_vital	= 'Ti')then
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_TI',Vetor_w[i].vl_sinal_vital);
		
		elsif (Vetor_w[i].nm_sinal_vital	= 'Te') then
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_TE',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'PA D') then
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_DIAST_AP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'PA S') then
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_SIST_AP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'PA M') then
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_MEDIA_AP',Vetor_w[i].vl_sinal_vital);
			
		elsif (Vetor_w[i].nm_sinal_vital	= 'SpO2') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SATURACAO_O2',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_SATURACAO_O2',Vetor_w[i].vl_sinal_vital);
		elsif	((Vetor_w[i].nm_sinal_vital	= 'NBP S' or Vetor_w[i].nm_sinal_vital	= 'NIBP_SYS')
                and ie_invasivo_w <> 'S') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_SISTOLICA',Vetor_w[i].vl_sinal_vital);
		elsif ((Vetor_w[i].nm_sinal_vital	= 'NBP D' or Vetor_w[i].nm_sinal_vital	= 'NIBP_DIA')
        and ie_invasivo_w <> 'S') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_DIASTOLICA',Vetor_w[i].vl_sinal_vital);
		elsif ((Vetor_w[i].nm_sinal_vital	= 'NBP M' or Vetor_w[i].nm_sinal_vital	= 'NIBP_MAP')
        and ie_invasivo_w <> 'S') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PAM',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'HR' or Vetor_w[i].nm_sinal_vital	= 'PR'
            or Vetor_w[i].nm_sinal_vital = 'NIBP_PR') then
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARD_MONIT',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARDIACA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_FC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_sinal_vital	= 'etCO2' or Vetor_w[i].nm_sinal_vital	= 'etCO2*') then
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_CO2',Vetor_w[i].vl_sinal_vital);
		end if;
	
		end;
	end loop;

    if (ie_invasivo_w = 'S') then
        select coalesce(max(CD_EXTERNO),'I')
        into STRICT cd_conversao_invasiva_w
        from CONVERSAO_MEIO_EXTERNO
        where NM_TABELA = 'ATENDIMENTO_SINAL_VITAL'
        and NM_ATRIBUTO = 'IE_APARELHO_PA'
        and CD_INTERNO = 'INV';
        atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA',cd_conversao_invasiva_w);
    elsif (ie_invasivo_w = 'X') then
        select coalesce(max(CD_EXTERNO),'E')
        into STRICT cd_conversao_w
        from CONVERSAO_MEIO_EXTERNO
        where NM_TABELA = 'ATENDIMENTO_SINAL_VITAL'
        and NM_ATRIBUTO = 'IE_APARELHO_PA'
        and CD_INTERNO = 'NAO';
        atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA',cd_conversao_w);
    end if;


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_sinal_vital_drager ( cd_pessoa_fisica_p text, dt_sinal_vital_p text, ds_lista_parametros_p text, nm_usuario_p text) FROM PUBLIC;

