-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_equip_agenda ( nr_seq_agenda_p bigint, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_equipamento_w			bigint;
nr_seq_classif_equip_w		bigint;
ie_utilizar_equip_presc_w	varchar(1);

C01 CURSOR FOR
	SELECT	cd_equipamento,
		nr_seq_classif_equip
	from	ageint_equip_item
	where	nr_seq_agenda_item	= nr_seq_item_p;

C02 CURSOR FOR
	SELECT	a.cd_equipamento
	from	agenda a,
			agenda_paciente ap
	where	ap.nr_sequencia = nr_seq_agenda_p
	and		ap.cd_agenda = a.cd_agenda;


BEGIN

ie_utilizar_equip_presc_w := Obter_Param_Usuario(869, 417, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_utilizar_equip_presc_w);

if (coalesce(ie_utilizar_equip_presc_w,'N') = 'N') then
	open C01;
	loop
	fetch C01 into
		cd_equipamento_w,
		nr_seq_classif_equip_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into agenda_pac_equip(nr_sequencia,
				nr_seq_agenda,
				dt_atualizacao,
				nm_usuario,
				cd_equipamento,
				nr_seq_classif_equip,
				ie_origem_inf,--I
				ie_obrigatorio)--S
			values (nextval('agenda_pac_equip_seq'),
				nr_seq_agenda_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_equipamento_w,
				nr_seq_classif_equip_w,
				'I',
				'S');
		end;
	end loop;
	close C01;
else
	open C02;
	loop
	fetch C02 into
		cd_equipamento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert into agenda_pac_equip(nr_sequencia,
				nr_seq_agenda,
				dt_atualizacao,
				nm_usuario,
				cd_equipamento,
				ie_origem_inf,--I
				ie_obrigatorio)--S
			values (nextval('agenda_pac_equip_seq'),
				nr_seq_agenda_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_equipamento_w,
				'I',
				'S');
		end;
	end loop;
	close C02;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_equip_agenda ( nr_seq_agenda_p bigint, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;

