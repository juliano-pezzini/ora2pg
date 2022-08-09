-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_vl_informado ( vl_informado_p text, nr_titulo_p bigint, ie_tipo_titulo_p text, nr_seq_pessoa_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_informado_tabela_w				double precision;

C01 CURSOR FOR
	SELECT	coalesce(vl_informado,0)
	from	encontro_contas_item
	where	nr_titulo_receber = nr_titulo_p
	and 	nr_seq_pessoa = nr_seq_pessoa_p;

C02 CURSOR FOR
	SELECT	coalesce(vl_informado,0)
	from	encontro_contas_item
	where	nr_titulo_pagar = nr_titulo_p
	and 	nr_seq_pessoa = nr_seq_pessoa_p;


BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	if (ie_tipo_titulo_p = 'R') then

		open C01;
			loop
			fetch C01 into
				vl_informado_tabela_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */

				if (vl_informado_tabela_w <> (vl_informado_p)::numeric ) then
					update	encontro_contas_item
					set	vl_informado = (vl_informado_p)::numeric
					where	nr_titulo_receber = nr_titulo_p
					and 	nr_seq_pessoa = nr_seq_pessoa_p;

				end if;

			end loop;
			close C01;

	elsif (ie_tipo_titulo_p = 'P') then

		open C02;
			loop
			fetch C02 into
				vl_informado_tabela_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */

				if vl_informado_tabela_w <> vl_informado_p then

					update	encontro_contas_item
					set	vl_informado = (vl_informado_p)::numeric
					where	nr_titulo_pagar = nr_titulo_p
					and 	nr_seq_pessoa = nr_seq_pessoa_p;

				end if;

			end loop;
			close C02;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_vl_informado ( vl_informado_p text, nr_titulo_p bigint, ie_tipo_titulo_p text, nr_seq_pessoa_p bigint, nm_usuario_p text) FROM PUBLIC;
