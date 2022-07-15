-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_medicamento ( nr_sequencia_p bigint, ie_menu_geral_p text, cd_medico_p text, nr_seq_medic_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_medic_w		bigint;
nr_seq_medic_copia_w	bigint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_menu_geral_p IS NOT NULL AND ie_menu_geral_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
	begin

	nr_seq_medic_copia_w := copia_medicamento_padrao(nr_sequencia_p, nr_seq_medic_copia_w, nm_usuario_p);

	if (ie_menu_geral_p = 'G') then
		begin

		select	max(nr_sequencia)
		into STRICT	nr_seq_medic_w
		from	med_medic_padrao
		where	coalesce(cd_medico::text, '') = ''
		and	cd_estabelecimento = cd_estabelecimento_p;

		end;
	else
		begin

		select	max(nr_sequencia)
		into STRICT	nr_seq_medic_w
		from	med_medic_padrao
		where	cd_medico = cd_medico_p;

		end;
	end if;

	commit;
	end;
end if;

nr_seq_medic_p	:= nr_seq_medic_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_medicamento ( nr_sequencia_p bigint, ie_menu_geral_p text, cd_medico_p text, nr_seq_medic_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

