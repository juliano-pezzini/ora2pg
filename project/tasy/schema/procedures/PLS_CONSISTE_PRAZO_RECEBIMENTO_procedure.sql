-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consiste_prazo_recebimento ( qt_dias_limite_p bigint, ie_tipo_data_envio_rec_p text, ie_tipo_data_envio_p text, cd_guia_referencia_p text, ie_tipo_guia_p text, nr_seq_segurado_p bigint, nr_seq_protocolo_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, ie_tipo_item_p bigint, cd_tiss_atendimento_p text, nm_usuario_p text, ds_observacao_p INOUT text, ie_limite_dt_recebimento_p INOUT text) AS $body$
DECLARE


ie_limite_dt_recebimento_w		varchar(1)	:= 'S';
ds_observacao_w				varchar(4000)	:= '';
dt_referencia_rec_w			timestamp;
nr_seq_conta_ref_w			bigint;

/*
ASKONO - 16-05-2012
CRIEI ESTA PROCEDURE PARA ENCAPSULAR A REGRA DE RECEBIMENTO, POIS NA PLS_GERAR_OCORRENCIA ESTAVA FICANDO EXTENSA.
*/
BEGIN

/*Demitrius permite escolher qual será a data de referencia para a restrição*/

/*data do protocolo*/

if (ie_tipo_data_envio_rec_p = 'P')	then
	select	coalesce(dt_protocolo,clock_timestamp())
	into STRICT	dt_referencia_rec_w
	from 	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_p;
/*Mês de competência*/

elsif (ie_tipo_data_envio_rec_p = 'C')	then
	select	coalesce(dt_mes_competencia,clock_timestamp())
	into STRICT	dt_referencia_rec_w
	from 	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_p;
/* Data recebimento protocolo*/

elsif (ie_tipo_data_envio_rec_p = 'R')	then
	select	coalesce(dt_recebimento,clock_timestamp())
	into STRICT	dt_referencia_rec_w
	from 	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_p;
else
	dt_referencia_rec_w	:= clock_timestamp();
end if;

/*Se for  contas médicas*/

/*ATENDIMENTO*/

if ( ie_tipo_data_envio_p = 'AT') then
	begin
	select	'S'
	into STRICT	ie_limite_dt_recebimento_w
	from	pls_protocolo_conta	b,
		pls_conta		a
	where	a.nr_seq_protocolo	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_conta_p
	and	trunc(a.dt_emissao) >= (trunc(dt_referencia_rec_w - qt_dias_limite_p)); --
	exception
	when others then
		ie_limite_dt_recebimento_w	:= 'N';
	end;

	if (ie_limite_dt_recebimento_w = 'N') then
		ds_observacao_w := substr(ds_observacao_w||'A data de emissão da conta é superior a '||qt_dias_limite_p||' dias da data de recebimento do protocolo.'||chr(13)||chr(10) ,1,4000);
	end if;
/* ALTA*/

elsif ( ie_tipo_data_envio_p = 'A') then
	/*Se a guia não for de internação não tem dt_alta.*/

	/*guia de internação*/

	if (ie_tipo_guia_p = '5') then
		begin
		select	'S'
		into STRICT	ie_limite_dt_recebimento_w
		from	pls_protocolo_conta 	b,
			pls_conta 		a
		where	a.nr_seq_protocolo	= b.nr_sequencia
		and	a.nr_sequencia 		= nr_seq_conta_p
		and	trunc(a.dt_alta) > (trunc(dt_referencia_rec_w - qt_dias_limite_p));
		exception
		when others then
			ie_limite_dt_recebimento_w	:= 'N';
		end;
	elsif	((ie_tipo_guia_p = '6') or
		(ie_tipo_guia_p = '4' AND cd_tiss_atendimento_p = '07')) then

		/*Encontrar a conta principal*/

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_conta_ref_w
		from	pls_conta
		where	nr_seq_segurado				= nr_seq_segurado_p
		and	coalesce(cd_guia_referencia,cd_guia)		= cd_guia_referencia_p
		and	ie_tipo_guia	= '5';

		if (coalesce(nr_seq_conta_ref_w,0) > 0) then
			begin
			select	'S'
			into STRICT	ie_limite_dt_recebimento_w
			from	pls_protocolo_conta	b,
				pls_conta 		a
			where	a.nr_seq_protocolo	= b.nr_sequencia
			and	a.nr_sequencia 		= nr_seq_conta_ref_w
			and	trunc(a.dt_alta) >= (trunc(dt_referencia_rec_w - qt_dias_limite_p));
			exception
			when others then
				ie_limite_dt_recebimento_w	:= 'N';
			end;
		else
			/*Se a conta não for encontrada não gera ESTA ocorrência.*/

			ie_limite_dt_recebimento_w	:= 'S';
		end if;
	else
		ie_limite_dt_recebimento_w	:= 'S';
	end if;

	if (ie_limite_dt_recebimento_w = 'N') then
		ds_observacao_w := substr(ds_observacao_w||'A data de alta da internação é superior a '||qt_dias_limite_p||' dias da data de recebimento do protocolo.'||chr(13)||chr(10) ,1,4000);
	end if;
--Diego OS 274134
/*PROCEDIMENTO*/

elsif (ie_tipo_data_envio_p = 'P') then

	begin
	select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_limite_dt_recebimento_w
	from	pls_conta		a,
		pls_protocolo_conta	b,
		pls_conta_proc		c
	where	a.nr_seq_protocolo = b.nr_sequencia
	and	c.nr_seq_conta	= a.nr_sequencia
	and	((c.nr_sequencia = nr_seq_conta_proc_p and ie_tipo_item_p = '3')
	or (c.nr_seq_conta = nr_seq_conta_p and ie_tipo_item_p = '8'))
	and	trunc(c.dt_procedimento) <= (trunc(dt_referencia_rec_w - qt_dias_limite_p));
	exception
	when others then
		ie_limite_dt_recebimento_w := 'N';
	end;

	if (ie_limite_dt_recebimento_w = 'N') then
		ds_observacao_w := substr(ds_observacao_w||'A data de execução do procedimento é superior a '||qt_dias_limite_p||' dias da data de recebimento do protocolo.'||chr(13)||chr(10) ,1,4000);
	end if;
/* Alexandre - OS  314921 */

/*MATERIAL*/

elsif (ie_tipo_data_envio_p = 'M') then

	begin
	select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_limite_dt_recebimento_w
	from	pls_conta		a,
		pls_protocolo_conta	b,
		pls_conta_mat		c
	where	a.nr_seq_protocolo	= b.nr_sequencia
	and	c.nr_seq_conta		= a.nr_sequencia
	and	((c.nr_sequencia = nr_seq_conta_mat_p and ie_tipo_item_p = 4)
	or (c.nr_seq_conta = nr_seq_conta_p and ie_tipo_item_p = 8))
	and	trunc(c.dt_atendimento) <= (trunc(dt_referencia_rec_w - qt_dias_limite_p));
	exception
	when others then
		ie_limite_dt_recebimento_w := 'N';
	end;

	if ( ie_limite_dt_recebimento_w = 'N') then
		ds_observacao_w := substr(ds_observacao_w||'A data de execução do material é superior a '||qt_dias_limite_p||' dias da data de recebimento do protocolo.'||chr(13)||chr(10)  ,1,4000);
	end if;

--Diego OS 311736 - Verificar a data de envio em relação a data de entrada na internação
/*ENTRADA*/

elsif (ie_tipo_data_envio_p = 'E') then

	/*Se a guia não for de internação não tem dt_alta.*/

	if (ie_tipo_guia_p = '5') then
		begin
		select	'S'
		into STRICT	ie_limite_dt_recebimento_w
		from	pls_protocolo_conta 	b,
			pls_conta 		a
		where	a.nr_seq_protocolo	= b.nr_sequencia
		and	a.nr_sequencia 		= nr_seq_conta_p
		and	trunc(a.dt_entrada) >= (trunc(dt_referencia_rec_w - qt_dias_limite_p));
		exception
		when others then
			ie_limite_dt_recebimento_w := 'N';
		end;
	elsif	((ie_tipo_guia_p = '6') or
		(ie_tipo_guia_p = '4' AND cd_tiss_atendimento_p = '07')) then

		/*Encontrar a conta principal*/

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_conta_ref_w
		from	pls_conta
		where	nr_seq_segurado				= nr_seq_segurado_p
		and	coalesce(cd_guia,cd_guia_referencia)		= cd_guia_referencia_p
		and	ie_tipo_guia		= '5';

		if (coalesce(nr_seq_conta_ref_w,0) > 0) then
			begin
			select	'S'
			into STRICT	ie_limite_dt_recebimento_w
			from	pls_protocolo_conta	b,
				pls_conta 		a
			where	a.nr_seq_protocolo	= b.nr_sequencia
			and	a.nr_sequencia 		= nr_seq_conta_ref_w
			and	trunc(a.dt_entrada) >= (trunc(dt_referencia_rec_w - qt_dias_limite_p));
			exception
			when others then
				ie_limite_dt_recebimento_w := 'N';
			end;
		else
			/*Se a conta não for encontrada não gera ESTA ocorrência.*/

			ie_limite_dt_recebimento_w := 'S';
		end if;
	else
		ie_limite_dt_recebimento_w := 'S';
	end if;

	if (ie_limite_dt_recebimento_w = 'N') then
		ds_observacao_w :=  substr(ds_observacao_w||'A data de entrada da internação é superior a '||qt_dias_limite_p||' dias da data de recebimento do protocolo.'||chr(13)||chr(10) ,1,4000);
	end if;
end if;

ie_limite_dt_recebimento_p	:= ie_limite_dt_recebimento_w;
ds_observacao_p 		:= ds_observacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consiste_prazo_recebimento ( qt_dias_limite_p bigint, ie_tipo_data_envio_rec_p text, ie_tipo_data_envio_p text, cd_guia_referencia_p text, ie_tipo_guia_p text, nr_seq_segurado_p bigint, nr_seq_protocolo_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, ie_tipo_item_p bigint, cd_tiss_atendimento_p text, nm_usuario_p text, ds_observacao_p INOUT text, ie_limite_dt_recebimento_p INOUT text) FROM PUBLIC;

