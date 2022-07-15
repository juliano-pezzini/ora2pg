-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_status_emprestimo ( nr_sequencia_p bigint, nr_seq_status_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_gera_recurso_w	varchar(1);
cd_equipamento_w	bigint;
cd_equipamento_agenda_w bigint;
nr_seq_agenda_w		agenda_pac_equip.nr_seq_agenda%type;
qt_equipamento_w	bigint;
ie_reprovado_w		varchar(1);
nr_seq_evento_w		bigint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_status_p IS NOT NULL AND nr_seq_status_p::text <> '') then

	select	max(cd_equipamento),
		max(nr_seq_agenda),
		max(cd_equipamento_agenda)
	into STRICT	cd_equipamento_w,
		nr_seq_agenda_w,
		cd_equipamento_agenda_w
	from	reserva_agenda_equip
	where	nr_sequencia = nr_sequencia_p;

	select	coalesce(max(ie_gera_recurso),'N'),
		coalesce(max(ie_reprovado),'N')
	into STRICT	ie_gera_recurso_w,
		ie_reprovado_w
	from	status_res_agenda_recurso
	where	nr_sequencia = nr_seq_status_p
	and	coalesce(ie_situacao,'A') = 'A';

	if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
		if (ie_gera_recurso_w = 'S') and (cd_equipamento_w IS NOT NULL AND cd_equipamento_w::text <> '') then

			select	count(*)
			into STRICT	qt_equipamento_w
			from	agenda_pac_equip
			where	cd_equipamento = cd_equipamento_w
			and	coalesce(ie_origem_inf,'I') = 'I'
			and	nr_seq_agenda = nr_seq_agenda_w;

			if (qt_equipamento_w = 0) then
				insert	into	agenda_pac_equip(
						nr_sequencia,
						nr_seq_agenda,
						dt_atualizacao,
						nm_usuario,
						cd_equipamento,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_origem_inf,
						ie_obrigatorio,
						ie_status_equipamento)
				values (nextval('agenda_pac_equip_seq'),
						nr_seq_agenda_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_equipamento_w,
						clock_timestamp(),
						nm_usuario_p,
						'I',
						'S',
						'E');
				update	agenda_pac_equip
				set	ie_origem_inf = 'E',
						dt_atualizacao = clock_timestamp(),
						nm_usuario = wheb_usuario_pck.get_nm_usuario
				where	cd_equipamento 	= cd_equipamento_agenda_w
				and	nr_seq_agenda	= nr_seq_agenda_w;
					
				select	max(nr_seq_evento)
				into STRICT	nr_seq_evento_w
				from	regra_envio_sms
				where	cd_estabelecimento		= cd_estabelecimento_p
				and	ie_evento_disp			= 'AEEA'
				and	coalesce(ie_situacao,'A') 		= 'A';
				if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
					CALL gerar_evento_agenda_cirurgica(nr_seq_evento_w,nr_seq_agenda_w,0,cd_equipamento_w,nm_usuario_p,cd_estabelecimento_p,'N');
				end if;
			end if;
		elsif (ie_reprovado_w = 'S') and (cd_equipamento_w IS NOT NULL AND cd_equipamento_w::text <> '') then
			select	max(nr_seq_evento)
			into STRICT	nr_seq_evento_w
			from	regra_envio_sms
			where	cd_estabelecimento		= cd_estabelecimento_p
			and	ie_evento_disp			= 'AREA'
			and	coalesce(ie_situacao,'A') 		= 'A';
			if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
				CALL gerar_evento_agenda_cirurgica(nr_seq_evento_w,nr_seq_agenda_w,0,cd_equipamento_w,nm_usuario_p,cd_estabelecimento_p,'N');
			end if;	
		end if;
		update	reserva_agenda_equip
		set	nr_seq_status 	= nr_seq_status_p
		where	nr_sequencia 	= nr_sequencia_p;
		commit;	
	end if;
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_status_emprestimo ( nr_sequencia_p bigint, nr_seq_status_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

