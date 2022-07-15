-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_desconto_excedente_conta ( nr_interno_conta_p bigint, nm_usuario_p text, vl_desconto_p bigint, vl_conta_p bigint ) AS $body$
DECLARE


nr_seq_desc_w		CONTA_PACIENTE_DESCONTO.nr_sequencia%type;
vl_conta_w			double precision := 0;
vl_desconto_w		CONTA_PACIENTE_DESCONTO.vl_desconto%type;
ie_gerar_desc_w		varchar(2);
ds_observacao_w		varchar(255);


BEGIN

--ds_observacao_w 	:= 'Gerado sistema - regra de excedente';
ds_observacao_w 	:= OBTER_DESC_EXPRESSAO(729064);

vl_conta_w 		:= vl_conta_p;
vl_desconto_w 	:= coalesce(vl_desconto_p,0);

if (vl_desconto_w < 0) then
	vl_desconto_w := (vl_desconto_w * -1);
end if;

if (coalesce(vl_conta_w,0) = 0 ) then
	vl_conta_w := obter_valor_conta(nr_interno_conta_p,0);
end if;

begin

	select 	nextval('conta_paciente_desconto_seq')
	into STRICT  	nr_seq_desc_w
	;

	ie_gerar_desc_w := 'S';

	insert into conta_paciente_desconto(nr_sequencia,
			nr_interno_conta,
			ie_tipo_desconto,
			dt_atualizacao,
			nm_usuario,
			vl_conta,
			pr_desconto,
			vl_desconto,
			vl_liquido,
			dt_desconto,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_pacote,
			ie_valor_inf,
			ie_classificacao,
			ds_observacao)
	values (nr_seq_desc_w,
			nr_interno_conta_p,
			2, -- Valor desconto
			clock_timestamp(),
			nm_usuario_p,
			vl_conta_w,
			0,
			vl_desconto_w,
			vl_conta_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			'A',
			'A',
			'D',
			ds_observacao_w);
	exception
		when others then
		ie_gerar_desc_w	:= 'N';
	end;

	if (ie_gerar_desc_w = 'S') then
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

		CALL Gerar_ConPaci_Desc_Item(nr_seq_desc_w,nm_usuario_p); /*CALCULAR ITENS*/
		CALL Gerar_Conv_Regra_Desc(nr_seq_desc_w,nm_usuario_p);

		--Calcular_ConPaci_Desc_Item(nr_seq_desc_w,nm_usuario_p);
		CALL Calcular_Conpaci_Desconto(nr_seq_desc_w,'I',nm_usuario_p);/*GERAR DESCONTO*/
	else
		rollback;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_desconto_excedente_conta ( nr_interno_conta_p bigint, nm_usuario_p text, vl_desconto_p bigint, vl_conta_p bigint ) FROM PUBLIC;

