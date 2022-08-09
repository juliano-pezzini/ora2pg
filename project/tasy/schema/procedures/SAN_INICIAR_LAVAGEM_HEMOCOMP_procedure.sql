-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_iniciar_lavagem_hemocomp ( nr_seq_lavagem_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_alterar_inicio_lavagem_w	varchar(1);
nr_seq_producao_w		bigint;
ie_alterar_dt_vencimento_w	varchar(1);
dt_vencimento_w			timestamp;


BEGIN

if (nr_seq_lavagem_p IS NOT NULL AND nr_seq_lavagem_p::text <> '') then

	ie_alterar_inicio_lavagem_w := obter_valor_param_usuario(450,351,obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
	ie_alterar_dt_vencimento_w  := obter_valor_param_usuario(450,449,obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);

	if (ie_alterar_inicio_lavagem_w = 'S') then
		select	max(nr_seq_producao),
			max(dt_vencimento)
		into STRICT	nr_seq_producao_w,
			dt_vencimento_w
		from	san_producao_lavagem
		where	nr_sequencia = nr_seq_lavagem_p;

		if (nr_seq_producao_w IS NOT NULL AND nr_seq_producao_w::text <> '') then
			update	san_producao
			set	ie_lavado 		= 'S',
				nm_usuario_lavado	= nm_usuario_p,
				dt_vencimento		= CASE WHEN ie_alterar_dt_vencimento_w='S' THEN dt_vencimento_w  ELSE dt_vencimento END
			where	nr_sequencia		= nr_seq_producao_w;
		end if;
	end if;

	update 	san_producao_lavagem
	set	dt_inicio_lavagem 	= clock_timestamp(),
		nm_usuario_ini		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_lavagem_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_iniciar_lavagem_hemocomp ( nr_seq_lavagem_p bigint, nm_usuario_p text) FROM PUBLIC;
