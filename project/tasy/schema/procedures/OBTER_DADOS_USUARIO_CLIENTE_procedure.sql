-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_usuario_cliente ( nr_sequencia_p bigint) AS $body$
DECLARE


cd_setor_atend_w	integer;
cd_cargo_w		integer;
vl_inf_w		varchar(100);
id_inf_w		varchar(100);
cd_cnpj_w		varchar(14);
ds_setor_atendimento_w	varchar(100);

C01 CURSOR FOR
	SELECT	c.cd_setor_atendimento,
		substr(obter_desc_expressao(c.cd_exp_setor_atend,c.ds_setor_atendimento),1,100)
	from	setor_atendimento c,
		usuario b,
		pessoa_fisica a
	where	c.cd_pessoa_resp = a.cd_pessoa_fisica
	and	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	group by c.cd_setor_atendimento, c.ds_setor_atendimento;


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	--Setor
		begin

		open c01;
		loop
		fetch c01 into cd_setor_atend_w, ds_setor_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			select	count(*),
				null,
				obter_cgc_estabelecimento(obter_estabelecimento_ativo)
			into STRICT	vl_inf_w,
				id_inf_w,
				cd_cnpj_w
			from	usuario a,
				setor_atendimento b
			where	b.cd_setor_atendimento = cd_setor_atend_w
			and	a.cd_setor_atendimento = b.cd_setor_atendimento;

			CALL insert_inf_base_cliente(
				nr_sequencia_p,
				vl_inf_w,
				ds_setor_atendimento_w,
				cd_cnpj_w,
				null,
				'Tasy');

			end;
		end loop;
		close c01;
		end;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_usuario_cliente ( nr_sequencia_p bigint) FROM PUBLIC;
