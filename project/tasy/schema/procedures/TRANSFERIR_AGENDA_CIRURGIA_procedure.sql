-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_agenda_cirurgia (cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_transferencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_transf_w			bigint;
nr_cirurgia_w			bigint;
cd_perfil_w				bigint;
ie_transfere_w			varchar(01);
cd_turno_w				varchar(01);
qt_hora_w				integer;
qt_bloqueio_periodo_w	bigint;
HR_QUEBRA_TURNO_w		varchar(05);
ie_passa_normal_w		varchar(05);
ds_alteracao_w			varchar(2000);/* Rafael em 03/01/2007 OS46794 */
 

BEGIN 
 
select	coalesce(max(HR_QUEBRA_TURNO), '12') 
into STRICT	HR_QUEBRA_TURNO_w 
from	agenda 
where 	cd_agenda	= cd_agenda_p;
 
select	(to_char(dt_transferencia_p,'hh24'))::numeric  
into STRICT	qt_hora_w
;
 
cd_turno_w	:= '0';
if (qt_hora_w >= somente_numero(HR_QUEBRA_TURNO_w)) then 
	cd_turno_w	:= '1';
end if;	
 
 
select	obter_perfil_ativo 
into STRICT	cd_perfil_w
;
 
ie_transfere_w := Obter_Param_Usuario(871, 310, cd_perfil_w, nm_usuario_p, 0, ie_transfere_w);
ie_passa_normal_w := Obter_Param_Usuario(39, 77, cd_perfil_w, nm_usuario_p, 0, ie_passa_normal_w);
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_seq_transf_w 
from	agenda_paciente 
where	hr_inicio		= dt_transferencia_p 
and	cd_agenda		= cd_agenda_p 
and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');
 
select	coalesce(max(nr_cirurgia),0) 
into STRICT	nr_cirurgia_w 
from	agenda_paciente 
where	nr_sequencia		= nr_seq_agenda_p;
 
if (nr_cirurgia_w > 0) and (ie_transfere_w = 'N') then 
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(266271);
end if;
 
if (nr_seq_transf_w > 0) then 
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(266274);
end if;
 
select 	count(*) 
into STRICT	qt_bloqueio_periodo_w 
from	agenda_paciente 
where	cd_agenda		= cd_agenda_p 
and	dt_agenda		= trunc(dt_transferencia_p, 'dd') 
and	ie_status_agenda	= 'B' 
and	hr_inicio		<= dt_transferencia_p 
and	hr_inicio		>= dt_transferencia_p;
 
if (qt_bloqueio_periodo_w > 0) then 
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(266275);
end if;
 
/* Rafael em 03/01/2007 OS46794 */
 
ds_alteracao_w	:= null;
ds_alteracao_w	:= '<transferir_agenda_cirurgia>' || ' dados da transferência = agenda: ' || to_char(cd_agenda_p) || 
			  obter_desc_expressao(291428)	||': '/*' horário: '*/ || to_char(dt_transferencia_p,'dd/mm/yyyy hh24:mi:ss') || 
			  obter_desc_expressao(726857)/*' atualização: '*/
 || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') || 
			  obter_desc_expressao(345973)/*' usuário: '*/
 || nm_usuario_p;
insert into agenda_historico_acao( 
					nr_sequencia, 
					ie_agenda, 
					cd_agenda, 
					nr_seq_agenda, 
					dt_agenda, 
					ie_acao, 
					dt_acao, 
					ds_acao, 
					ds_alteracao 
					) 
					SELECT	nextval('agenda_historico_acao_seq'), 
						obter_tipo_agenda(cd_agenda), 
						cd_agenda, 
						nr_seq_agenda_p, 
						hr_inicio, 
						'T', 
						clock_timestamp(), 
						obter_desc_expressao(325811)	/*' paciente: '*/
		|| coalesce(cd_pessoa_fisica,nm_paciente)			|| 
						obter_desc_expressao(625240) 	|| ' ' || ie_status_agenda						|| 
						obter_desc_expressao(622367)	/*' médico: '*/
		|| cd_medico							|| 
						obter_desc_expressao(296423)	/*' proced: '*/
		|| to_char(cd_procedimento)					|| 
						obter_desc_expressao(327633)	/*' origem: '*/
		|| to_char(ie_origem_proced)				|| 
						obter_desc_expressao(697085)	||': '/*' interno: '*/		|| to_char(nr_seq_proc_interno)				|| 
						obter_desc_expressao(302532)	||': '/*' agendamento: '*/	|| to_char(dt_agendamento,'dd/mm/yyyy hh24:mi:ss')	|| 
						obter_desc_expressao(345973)	/*' usuário: '*/
		|| nm_usuario_orig, 
						ds_alteracao_w 
					from	agenda_paciente 
					where	nr_sequencia = nr_seq_agenda_p;						
/* Fim alteração Rafael em 03/01/2007 OS46794 */
 
 
update	agenda_paciente 
set	dt_agenda		= trunc(dt_transferencia_p, 'dd'), 
	hr_inicio		= dt_transferencia_p, 
	cd_turno		= cd_turno_w, 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp(), 
	cd_agenda		= cd_agenda_p, 
	ie_status_agenda	= CASE WHEN coalesce(ie_passa_normal_w, 'N')='S' THEN  'N'  ELSE ie_status_agenda END , 
	nm_usuario_orig		= coalesce(nm_usuario_orig, nm_usuario_p) 
where	nr_sequencia		= nr_seq_agenda_p;
 
update	cirurgia 
set	dt_inicio_prevista	= dt_transferencia_p, 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp() 
where	nr_cirurgia		= nr_cirurgia_w 
and	ie_status_cirurgia	= 1;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_agenda_cirurgia (cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_transferencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
