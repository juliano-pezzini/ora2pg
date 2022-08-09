-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ratear_desconto_convenio (nr_seq_retorno_p bigint, ds_seq_ret_item_p text, vl_rateio_p bigint, nm_usuario_p text, ie_ajuste_p bigint, ie_commit_p text, ie_aplicar_itens_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


/*	ie_ajuste_p

0	Não ajustar
1	Não ratear se o valor ultrapassar o saldo da guia
2	Se necessário, ajustar o desconto conforme o saldo disponível

*/
vl_total_w		double precision	:= 0;	/* valor base do cálculo do rateio */
vl_guia_w		double precision	:= 0;	/* valor da guia. O rateio será proporcional a este valor */
vl_desconto_item_w	double precision	:= 0;	/* resultado do rateio para o item selecionado no cursor */
vl_total_desconto_w	double precision	:= 0;	/* valor total rateado para todas as guias */
nr_seq_ret_item_w	bigint;
vl_saldo_w		double precision;
vl_retorno_w		double precision;		/* valor total do retorno selecionado */
vl_desconto_w		double precision;
vl_diferenca_w		double precision	:= 0;
vl_pago_w		double precision	:= 0;
ds_consistencia_w	varchar(4000);

nr_sequencia_w		convenio_retorno_glosa.nr_sequencia%type;
vl_pago_item_w		double precision;
vl_cobrado_w		convenio_retorno_glosa.vl_cobrado%type;
vl_desconto_item_ww	double precision	:= 0;

c01 CURSOR FOR
SELECT	coalesce(b.vl_guia,0) vl_guia,
	a.nr_sequencia nr_seq_ret_item,
	coalesce(obter_saldo_conpaci(a.nr_interno_conta,a.cd_autorizacao),0) vl_saldo,
	coalesce(a.vl_pago,0) + coalesce(a.vl_desconto,0) + coalesce(a.vl_perdas,0) + coalesce(a.vl_nota_credito,0) + coalesce(a.vl_glosado,0) vl_retorno,
	coalesce(a.vl_desconto,0) vl_desconto,
	coalesce(a.vl_pago,0) vl_pago
from	conta_paciente_guia b,
	convenio_retorno_item a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	a.nr_interno_conta	= b.nr_interno_conta
and	a.cd_autorizacao	= b.cd_autorizacao
and	(((coalesce(position(a.nr_sequencia||',' in ds_seq_ret_item_p),0) > 0) and (ds_seq_ret_item_p IS NOT NULL AND ds_seq_ret_item_p::text <> '')) or (coalesce(ds_seq_ret_item_p::text, '') = ''))
order 	by a.vl_guia;

c02 CURSOR FOR
SELECT	nr_sequencia,
	(obter_dados_ret_movto_glosa(nr_sequencia, 3))::numeric  vl_pago,
	vl_cobrado
from	convenio_retorno_glosa
where	nr_seq_ret_item = nr_seq_ret_item_w
and	coalesce(ie_aplicar_itens_p,'N') = 'S';


BEGIN

if (coalesce(vl_rateio_p,0) <> 0) then

	select	coalesce(sum(b.vl_guia),0)
	into STRICT	vl_total_w
	from	conta_paciente_guia b,
		convenio_retorno_item a
	where	a.nr_seq_retorno	= nr_seq_retorno_p
	and	a.nr_interno_conta	= b.nr_interno_conta
	and	a.cd_autorizacao	= b.cd_autorizacao;

	open	c01;
	loop
	fetch	c01 into
		vl_guia_w,
		nr_seq_ret_item_w,
		vl_saldo_w,
		vl_retorno_w,
		vl_desconto_w,
		vl_pago_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if	((vl_saldo_w - vl_retorno_w) >= 0) or (coalesce(ie_ajuste_p,0) = 0) then

			vl_desconto_item_w	:= (vl_rateio_p * vl_guia_w) / vl_total_w;

			/* ajustar os valores de acordo com o saldo disponível */

			if	((vl_saldo_w - (vl_retorno_w - vl_desconto_item_w)) < 0) and (coalesce(ie_ajuste_p,0) = 0) and (coalesce(length(ds_consistencia_w),0) <= 3990) then
				ds_consistencia_w	:= ds_consistencia_w || nr_seq_ret_item_w || ', ';
			end if;

			while(coalesce(ie_ajuste_p,0) <> 0) and ((vl_saldo_w - vl_retorno_w - vl_desconto_item_w) < 0) loop
				begin
				if (ie_ajuste_p = 1) and (coalesce(length(ds_consistencia_w),0) <= 3990) then
					ds_consistencia_w	:= ds_consistencia_w || nr_seq_ret_item_w || ', ';
					vl_desconto_item_w	:= 0;
				elsif (ie_ajuste_p = 2) then
					vl_desconto_item_w	:= vl_desconto_item_w + (vl_saldo_w - vl_retorno_w - vl_desconto_item_w);
				end if;
				end;
			end loop;
			/* fim dos ajustes de valor */

			vl_total_desconto_w	:= vl_total_desconto_w + vl_desconto_item_w;

			if (vl_pago_w > 0) then
				vl_pago_w	:= coalesce(vl_pago_w,0) - coalesce(vl_desconto_item_w,0);
			end if;

			update	convenio_retorno_item
			set	vl_desconto	= coalesce(vl_desconto,0) + vl_desconto_item_w,
				vl_pago		= vl_pago_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_ret_item_w;

			open	c02;
			loop
			fetch	c02 into
				nr_sequencia_w,
				vl_pago_item_w,
				vl_cobrado_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */

				vl_desconto_item_ww	:= (vl_desconto_item_w * vl_cobrado_w) / vl_guia_w;

				update 	convenio_retorno_glosa
				set	vl_desconto_item = coalesce(vl_desconto_item,0) + vl_desconto_item_ww
				where	nr_sequencia = nr_sequencia_w;

			end	loop;
			close	c02;

		elsif (coalesce(length(ds_consistencia_w),0) <= 3990) then
			ds_consistencia_w	:= ds_consistencia_w || nr_seq_ret_item_w || ', ';
		end if;

	end	loop;
	close	c01;

	if (coalesce(ie_ajuste_p,0) = 0) or (((vl_saldo_w - vl_retorno_w) - (vl_rateio_p - vl_total_desconto_w) - vl_desconto_item_w) >= 0) then

		vl_diferenca_w	:= vl_rateio_p - vl_total_desconto_w;

		update	convenio_retorno_item
		set	vl_desconto	= vl_desconto_w + vl_desconto_item_w + vl_diferenca_w,
			vl_pago		= vl_pago - vl_diferenca_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_ret_item_w;

		open	c02;
		loop
		fetch	c02 into
			nr_sequencia_w,
			vl_pago_item_w,
			vl_cobrado_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			vl_desconto_item_ww	:= (vl_diferenca_w * vl_cobrado_w) / vl_guia_w;

			update 	convenio_retorno_glosa
			set	vl_desconto_item = coalesce(vl_desconto_item,0) + vl_desconto_item_ww
			where	nr_sequencia = nr_sequencia_w;

		end	loop;
		close	c02;

	end if;

	if (ds_consistencia_w IS NOT NULL AND ds_consistencia_w::text <> '') then
		/*ds_retorno_p	:= 	substr('Valor total rateado: ' || (vl_total_desconto_w + vl_diferenca_w) || chr(13) || chr(10) ||
					'O valor do rateio ultrapassa o saldo das seguintes guias: ' || chr(13) || chr(10) ||
					substr(ds_consistencia_w,1,nvl(length(ds_consistencia_w),0) - 2), 1, 255);*/
		ds_retorno_p	:= 	substr(wheb_mensagem_pck.get_texto(311872, 'VL_TOTAL_RATEADO=' || (vl_total_desconto_w + vl_diferenca_w)) || chr(13) || chr(10) ||
					wheb_mensagem_pck.get_texto(311873) || chr(13) || chr(10) ||
					substr(ds_consistencia_w,1,coalesce(length(ds_consistencia_w),0) - 2), 1, 255);
	else
		/*ds_retorno_p	:=	substr('Rateio realizado com sucesso!' || chr(13) || chr(10) ||
					'Valor total rateado: ' || (vl_total_desconto_w + vl_diferenca_w), 1, 255);*/
		ds_retorno_p	:=	substr(wheb_mensagem_pck.get_texto(311871) || chr(13) || chr(10) ||
					wheb_mensagem_pck.get_texto(311872, 'VL_TOTAL_RATEADO=' || (vl_total_desconto_w + vl_diferenca_w)), 1, 255);
	end if;

	if (ie_commit_p = 'S') then
		commit;
	end if;

else
	--ds_retorno_p	:= 'Valor à ratear não informado!';
	ds_retorno_p	:= wheb_mensagem_pck.get_texto(311870);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ratear_desconto_convenio (nr_seq_retorno_p bigint, ds_seq_ret_item_p text, vl_rateio_p bigint, nm_usuario_p text, ie_ajuste_p bigint, ie_commit_p text, ie_aplicar_itens_p text, ds_retorno_p INOUT text) FROM PUBLIC;
