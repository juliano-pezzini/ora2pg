-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_anest_escala_afast (nr_seq_anest_afast_p bigint, ie_opcao_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text) AS $body$
DECLARE


cd_profissional_w		varchar(10);
cd_profissional_subst_w		varchar(10);
nr_seq_escala_w			bigint;
dt_inicio_w			timestamp;
dt_final_w			timestamp;
nr_seq_escala_adic_w		bigint;
ds_escala_w			varchar(100);
ds_mensagem_w			varchar(4000);

/*
0 - excluir
1 - alterar
*/
c01 CURSOR FOR
	SELECT 	a.nr_sequencia
	from	escala_diaria_adic a,
		escala_diaria b
	where	a.nr_seq_escala_diaria = b.nr_sequencia
	and	a.cd_pessoa_fisica = cd_profissional_w
	and	((b.nr_seq_escala = nr_seq_escala_w) or (coalesce(nr_seq_escala_w::text, '') = ''))
	AND	((b.dt_inicio BETWEEN dt_inicio_w AND dt_final_w) OR (b.dt_fim BETWEEN dt_inicio_w AND dt_final_w) OR (b.dt_inicio < dt_inicio_w) AND (b.dt_fim > dt_final_w));

c02 CURSOR FOR
	SELECT 	distinct substr(OBTER_DESC_ESCALA(b.nr_seq_escala),1,100)
	from	escala_diaria_adic a,
		escala_diaria b
	where	a.nr_seq_escala_diaria = b.nr_sequencia
	and	a.cd_pessoa_fisica = cd_profissional_w
	and	((b.nr_seq_escala = nr_seq_escala_w) or (coalesce(nr_seq_escala_w::text, '') = ''))
	AND	((b.dt_inicio BETWEEN dt_inicio_w AND dt_final_w) OR (b.dt_fim BETWEEN dt_inicio_w AND dt_final_w) OR (b.dt_inicio < dt_inicio_w) AND (b.dt_fim > dt_final_w));

BEGIN

if (nr_seq_anest_afast_p > 0) and (ie_opcao_p <> 2) then

	select 	cd_profissional,
		cd_profissional_subst,
		nr_seq_escala,
		dt_inicio + (1/86400),
		dt_final
	into STRICT	cd_profissional_w,
		cd_profissional_subst_w,
		nr_seq_escala_w,
		dt_inicio_w,
		dt_final_w
	from	escala_afastamento_prof
	where 	nr_sequencia = nr_seq_anest_afast_p;

	open c02;
	loop
		fetch c02 into	ds_escala_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

		ds_mensagem_w	:= ds_mensagem_w || ds_escala_w || chr(10);

	end loop;
	close c02;

	if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
		ds_mensagem_p := Wheb_mensagem_pck.get_texto(307845, 'DS_MENSAGEM_W='||ds_mensagem_w);  --'Escalas atualizadas: ' || chr(10) || ds_mensagem_w;
	end if;

	open c01;
	loop
		fetch c01 into	nr_seq_escala_adic_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */


		if (ie_opcao_p = 0) then

			delete	FROM escala_diaria_adic
			where	nr_sequencia = nr_seq_escala_adic_w;

		end if;


		if (ie_opcao_p = 1) then

			if (coalesce(cd_profissional_subst_w::text, '') = '') then

				--Não é possível substituir o anestesista, pois não foi informado a pessoa que ira subtituí-lo');
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(261560);

			end if;

			update	escala_diaria_adic
			set	cd_pessoa_fisica = cd_profissional_subst_w,
				nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_seq_escala_adic_w
			and	(cd_profissional_subst_w IS NOT NULL AND cd_profissional_subst_w::text <> '');

		end if;
	end loop;
	close c01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_anest_escala_afast (nr_seq_anest_afast_p bigint, ie_opcao_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text) FROM PUBLIC;

