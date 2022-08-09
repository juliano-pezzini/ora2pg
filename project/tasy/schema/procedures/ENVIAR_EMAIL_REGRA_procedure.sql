-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_regra ( nr_seq_agenda_p bigint, ie_momento_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_paciente_internado_w	varchar(1);
nr_seq_proc_servico_w	bigint;	
cd_cgc_w                varchar(14);
ie_tipo_convenio_w	smallint;
cd_pessoa_fisica_w	varchar(10);
nr_atendimento_w	bigint;			
nr_seq_regra_w		bigint;
ds_mensagem_w		varchar(4000);	
ds_titulo_w		varchar(2000);
ds_email_remetente_w	varchar(255);
ds_seq_regra_email_w	varchar(255);
ds_lista_regras_w	varchar(255);
ds_email_destino_w	varchar(2000);
ie_aborta_email_w	varchar(1);
ie_clinica_w		integer;	
dt_agendamento_w	timestamp;	
dt_entrada_w		timestamp;
ie_datas_iguais_w	varchar(1);
ie_email_por_servico_w 	varchar(1);
ie_carater_cirurgia_w	varchar(1);
ie_enviar_sempre_w	varchar(1);
dt_agenda_w		timestamp;
							
c01 CURSOR FOR
	SELECT	distinct nr_seq_proc_servico, cd_cgc
	from	agenda_pac_servico
	where	nr_seq_agenda = nr_seq_agenda_p
	and	ie_email_por_servico_w = 'S'
	
union

	SELECT  0, ''
	;		

c02 CURSOR FOR
	SELECT	d.ds_email_destino,
		d.nr_sequencia,
		coalesce(d.ie_enviar_sempre,'N')
	from   	param_regra_envia_email c,
		regra_envio_email_agenda d
	where	c.nr_seq_regra	= d.nr_sequencia
	and     d.ie_momento          	= ie_momento_p
	and	((ie_momento_p <> 'SA') 
		 or (Obter_Se_Contido(d.nr_sequencia,ds_seq_regra_email_w)= 'N'))
	and (coalesce(c.nr_seq_proc_servico,nr_seq_proc_servico_w) 		= nr_seq_proc_servico_w)
	and (coalesce(c.cd_cgc,coalesce(cd_cgc_w,'xpto')) 		= coalesce(cd_cgc_w,'xpto'))
	and (coalesce(c.ie_tipo_convenio,coalesce(ie_tipo_convenio_w,0)) 		= coalesce(ie_tipo_convenio_w,0))
	and (coalesce(c.ie_paciente_internado,coalesce(ie_paciente_internado_w,'N')) 	= coalesce(ie_paciente_internado_w,'N'))
	and (coalesce(c.ie_clinica,ie_clinica_w) 				= ie_clinica_w)
	and (coalesce(c.ie_carater_cirurgia,coalesce(ie_carater_cirurgia_w,'XPTO')) 		= coalesce(ie_carater_cirurgia_w,'XPTO'))
	and	((coalesce(ie_datas_iguais,'N') = 'N') or (ie_datas_iguais_w = 'S'))
	and (coalesce(d.cd_estabelecimento,coalesce(cd_estabelecimento_p,0))  =   coalesce(cd_estabelecimento_p,0))
	and	((coalesce(qt_dias,0) = 0) or (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda_w) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agendamento_w) and ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agendamento_w + qt_dias)));


BEGIN

ds_email_remetente_w := obter_param_usuario(871, 20, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ds_email_remetente_w);
ie_email_por_servico_w := obter_param_usuario(871, 357, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_email_por_servico_w);

select 	max(cd_pessoa_fisica),
	max(nr_atendimento),
	max(coalesce(ds_seq_regra_email,'-1')),
	max(dt_agendamento),
	max(ie_carater_cirurgia),
	max(dt_agenda)
into STRICT	cd_pessoa_fisica_w,
	nr_atendimento_w,
	ds_seq_regra_email_w,
	dt_agendamento_w,
	ie_carater_cirurgia_w,
	dt_agenda_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_p;	


if (coalesce(nr_atendimento_w::text, '') = '') then
	select	coalesce(max(a.nr_atendimento),0)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente a,
		atend_categoria_convenio b
	where	a.nr_atendimento = b.nr_atendimento
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_w;
end if;	

select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_paciente_internado_w
from	atendimento_paciente
where	coalesce(dt_alta::text, '') = ''
and		ie_tipo_atendimento = 1
and 	nr_atendimento = nr_atendimento_w;

select	coalesce(max(ie_tipo_convenio),0),
	coalesce(max(ie_clinica),0),
	max(dt_entrada)
into STRICT	ie_tipo_convenio_w,
	ie_clinica_w,
	dt_entrada_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_w;

if (ie_tipo_convenio_w = 0) then
	select	max(Obter_Tipo_Convenio(cd_convenio))
	into STRICT	ie_tipo_convenio_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_agenda_p;
end if;	

ie_datas_iguais_w	:= 'N';
if (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agendamento_w) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_w)) then
	ie_datas_iguais_w := 'S';
end if;


open c01;
	loop
	fetch c01 into
	nr_seq_proc_servico_w,
	cd_cgc_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		open c02;
			loop
			fetch c02 into
				ds_email_destino_w,
				nr_seq_regra_w,
				ie_enviar_sempre_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */	
				begin

				if (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') and (ds_email_remetente_w IS NOT NULL AND ds_email_remetente_w::text <> '') then
					begin
					select	obter_conteudo_email_regra(nr_seq_agenda_p,nr_seq_regra_w,'T',nr_atendimento_w),
						obter_conteudo_email_regra(nr_seq_agenda_p,nr_seq_regra_w,'C',nr_atendimento_w)
					into STRICT	ds_titulo_w,
						ds_mensagem_w
					;
					
					if (ie_enviar_sempre_w = 'S') or (ie_momento_p <> 'SA') then
						CALL enviar_email(ds_titulo_w,ds_mensagem_w,ds_email_remetente_w,ds_email_destino_w,nm_usuario_p,'M');
					else	
						begin
						select	Obter_Se_Contido(nr_seq_regra_w,ds_lista_regras_w)
						into STRICT	ie_aborta_email_w
						;
						if (ie_aborta_email_w = 'N') then
							CALL enviar_email(ds_titulo_w,ds_mensagem_w,ds_email_remetente_w,ds_email_destino_w,nm_usuario_p,'M');
						end if;	
						end;
					end if;	
					
					if (ie_enviar_sempre_w = 'N') then
						if (coalesce(ds_lista_regras_w::text, '') = '') then
							ds_lista_regras_w := nr_seq_regra_w;
						else	
							ds_lista_regras_w := ds_lista_regras_w || ',' || nr_seq_regra_w;
						end if;	
					end if;	
					end;
				end if;	
				end;
			end loop;
		close c02;
		end;
	end loop;
close c01;

if (ds_lista_regras_w IS NOT NULL AND ds_lista_regras_w::text <> '') then
	begin
	update	agenda_paciente
	set	ds_seq_regra_email 	= ds_seq_regra_email_w || ',' || ds_lista_regras_w,
		dt_envio_email		= clock_timestamp()	
	where	nr_sequencia 		= nr_seq_agenda_p;
	commit;
	end;
end if;	
	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_regra ( nr_seq_agenda_p bigint, ie_momento_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
