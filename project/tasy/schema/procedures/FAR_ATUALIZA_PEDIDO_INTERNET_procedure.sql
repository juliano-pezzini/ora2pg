-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_atualiza_pedido_internet ( nr_seq_pedido_p bigint, nr_cpf_p text, nr_seq_contrato_p bigint, nr_seq_vendedor_p bigint, nr_crm_p text, ie_tipo_complemento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_entrega_w		bigint;
ds_endereco_w		varchar(100);
cd_cep_w		varchar(15);
nr_endereco_w		integer;
ds_complemento_w		varchar(40);
ds_bairro_w		varchar(80);
ds_municipio_w		varchar(40);
sg_estado_w		compl_pessoa_fisica.sg_estado%type;
cd_pessoa_fisica_w	varchar(10);

nr_seq_forma_pagto_w	bigint;
nr_seq_pagamento_w	bigint;
qt_existe_w		bigint;

c01 CURSOR FOR
SELECT	nr_sequencia
from	far_forma_pagamento
where	ie_situacao = 'A';


BEGIN

update	far_pedido
set	nr_cpf = nr_cpf_p,
	ie_cpf_nota = CASE WHEN nr_cpf_p='' THEN 'N'  ELSE 'S' END ,
	nr_crm = nr_crm_p,
	nr_seq_vendedor = nr_seq_vendedor_p,
	nr_seq_contrato_conv = nr_seq_contrato_p,
	dt_inicio_atendimento = clock_timestamp(),
	ie_status_pedido = 'A'
where	nr_sequencia = nr_seq_pedido_p;

if (coalesce(ie_tipo_complemento_p,0) > 0) then
	begin

	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	far_pedido
	where	nr_sequencia = nr_seq_pedido_p;

	select	ds_endereco,
		cd_cep,
		nr_endereco,
		ds_complemento,
		ds_bairro,
		ds_municipio,
		sg_estado
	into STRICT	ds_endereco_w,
		cd_cep_w,
		nr_endereco_w,
		ds_complemento_w,
		ds_bairro_w,
		ds_municipio_w,
		sg_estado_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and	ie_tipo_complemento = ie_tipo_complemento_p;

	select	nextval('far_pedido_endereco_seq')
	into STRICT	nr_seq_entrega_w
	;

	insert into far_pedido_endereco(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_pedido,
		ie_tipo_endereco,
		ds_endereco,
		cd_cep,
		nr_endereco,
		ds_complemento,
		ds_bairro,
		ds_municipio,
		sg_estado) values (
			nr_seq_entrega_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_pedido_p,
			ie_tipo_complemento_p,
			ds_endereco_w,
			cd_cep_w,
			nr_endereco_w,
			ds_complemento_w,
			substr(ds_bairro_w,1,40),
			ds_municipio_w,
			sg_estado_w);

	end;
end if;

select	count(*)
into STRICT	qt_existe_w
from	far_pedido_forma_pagto
where	nr_seq_pedido = nr_seq_pedido_p;

if (qt_existe_w = 0) then
	begin

	open c01;
	loop
	fetch c01 into
		nr_seq_forma_pagto_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	nextval('far_pedido_forma_pagto_seq')
		into STRICT	nr_seq_pagamento_w
		;

		insert into far_pedido_forma_pagto(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_pedido,
			nr_seq_forma_pagto,
			vl_pagamento) values (
				nr_seq_pagamento_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_pedido_p,
				nr_seq_forma_pagto_w,
				0);

		end;
	end loop;
	close c01;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_atualiza_pedido_internet ( nr_seq_pedido_p bigint, nr_cpf_p text, nr_seq_contrato_p bigint, nr_seq_vendedor_p bigint, nr_crm_p text, ie_tipo_complemento_p bigint, nm_usuario_p text) FROM PUBLIC;

