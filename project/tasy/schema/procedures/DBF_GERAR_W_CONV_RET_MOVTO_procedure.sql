-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dbf_gerar_w_conv_ret_movto (nr_seq_retorno_p bigint) AS $body$
DECLARE


cd_tipo_reg_w		convenio_retorno_movto.cd_tipo_registro%type;
dt_execucao_w		convenio_retorno_movto.dt_execucao%type;
nr_doc_convenio_w	convenio_retorno_movto.nr_doc_convenio%type;
nr_doc_convenio_ww	convenio_retorno_movto.nr_doc_convenio%type;
cd_usuario_conv_w	convenio_retorno_movto.cd_usuario_convenio%type;
ds_complemento_w	convenio_retorno_movto.ds_complemento%type;
cd_item_w		convenio_retorno_movto.cd_item%type;
vl_pago_w		convenio_retorno_movto.vl_pago%type;
vl_cobrado_w		convenio_retorno_movto.vl_cobrado%type;
vl_glosa_w		convenio_retorno_movto.vl_glosa%type;
cd_convenio_w		convenio_retorno.cd_convenio%type;
nr_interno_conta_w	conta_paciente_guia.nr_interno_conta%type;
vl_guia_w		convenio_retorno_movto.vl_glosa%type;
nr_conta_w		convenio_retorno_movto.nr_conta%type;
nr_titulo_w  		bigint;
vl_saldo_w  		bigint;
vl_pago_total_w 	bigint;
nr_mes_conta_disp_pg_w	varchar(10);
nr_mes_conta_disp_w	varchar(10);
vl_pago_char_w		varchar(30);
ie_guia_numero_w	varchar(1);
ds_portador_w		portador.ds_portador%type;
qt_w 			bigint;
cd_estab_w		estabelecimento.cd_estabelecimento%type;
nm_usuario_w		usuario.nm_usuario%type;
ie_glosa_w		varchar(1);
ie_permite_glosa_w	varchar(1);
ie_glosa_pend_amenor_w	varchar(1);
ie_imp_guia_duplicada_w	varchar(1);
ie_doc_retorno_w	varchar(10);
vl_glosado_w		bigint;
vl_adicional_w		bigint;
vl_amenor_w		bigint;
cd_motivo_w		bigint;

ie_gerar_movto_w	varchar(1);

C01 CURSOR FOR
SELECT	
	substr(obter_valor_campo_separador(ds_conteudo, 1, ';'),1,30) guia,
	coalesce(obter_valor_campo_separador(ds_conteudo, 2, ';'),0) vl_pago
from	w_conv_ret_movto a
where	a.nr_seq_retorno = nr_seq_retorno_p
and	substr(obter_valor_campo_separador(ds_conteudo, 3, ';'), 1, 2) = 'S';


BEGIN
ie_gerar_movto_w := 'S';
cd_estab_w	:= wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w	:= wheb_usuario_pck.get_nm_usuario;

nr_mes_conta_disp_pg_w := obter_param_usuario(27, 009, obter_perfil_ativo, nm_usuario_w, cd_estab_w, nr_mes_conta_disp_pg_w);
nr_mes_conta_disp_w := obter_param_usuario(27, 044, obter_perfil_ativo, nm_usuario_w, cd_estab_w, nr_mes_conta_disp_w);
ie_glosa_pend_amenor_w := obter_param_usuario(27, 124, obter_perfil_ativo, nm_usuario_w, cd_estab_w, ie_glosa_pend_amenor_w);
ie_imp_guia_duplicada_w := obter_param_usuario(27, 243, obter_perfil_ativo, nm_usuario_w, cd_estab_w, ie_imp_guia_duplicada_w);

select	r.cd_convenio,
	coalesce(coalesce(r.IE_DOC_RETORNO,ce.ie_doc_retorno),c.ie_doc_retorno)
into STRICT	cd_convenio_w,
	ie_doc_retorno_w
from	convenio_retorno r,
	convenio c,
	convenio_Estabelecimento ce
where	r.cd_convenio	= c.cd_convenio
and	r.cd_estabelecimento = ce.cd_estabelecimento
and 	ce.cd_convenio = c.cd_convenio
and	r.nr_sequencia = nr_seq_retorno_p;

open c01;
loop
fetch c01 into
	nr_doc_convenio_w,
	vl_pago_char_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
		vl_pago_w 	:= (replace(vl_pago_char_w, '.', ''))::numeric;
	exception
	when others then
		vl_pago_w	:= 0;
	end;			
	
	if (ie_doc_retorno_w = 'GUIA') then
		select	max(a.nr_interno_conta),
			max(b.vl_guia),
			max(OBTER_TITULO_CONTA_GUIA(a.nr_interno_Conta,b.cd_autorizacao,null,a.nr_seq_protocolo))
		into STRICT  	nr_conta_w,
			vl_guia_w,
			nr_titulo_w
		from 	conta_paciente a, conta_paciente_guia b 
		where 	a.nr_interno_conta = b.nr_interno_conta 
		and 	a.ie_status_acerto = 2
		and 	coalesce(a.ie_cancelamento::text, '') = '' 
		and 	coalesce(b.dt_convenio,clock_timestamp()) >= (clock_timestamp() - (nr_mes_conta_disp_pg_w * 30))
		and 	coalesce(a.dt_mesano_referencia,clock_timestamp()) >=  (clock_timestamp() - (nr_mes_conta_disp_w * 30)) 
		and 	a.cd_convenio_parametro = cd_convenio_w 
		and 	b.cd_autorizacao = nr_doc_convenio_w 
		and 	a.cd_estabelecimento = cd_estab_w;

		if (nr_conta_w = '') then
			
			nr_conta_w := null;
		
		elsif (coalesce(nr_conta_w,'') <> '') then
			
			select 	sum(vl_pago + vl_glosado + coalesce(vl_desconto,0))
			into STRICT 	vl_pago_total_w
			from 	convenio_retorno_item 
			where 	nr_interno_conta 	= nr_conta_w
			and 	cd_autorizacao 		= nr_doc_convenio_w;
			
			vl_saldo_w := (vl_guia_w - vl_pago_total_w);
		
		end if;
	elsif (ie_doc_retorno_w = 'ATCTGUIA') then
      			
		select 	max(a.nr_interno_conta),
			max(b.vl_guia)
		into STRICT  	nr_conta_w,
			vl_guia_w
		from 	conta_paciente a, 
			conta_paciente_guia b
		where 	a.nr_interno_conta = b.nr_interno_conta
		and 	a.ie_status_acerto = 2
		and 	coalesce(a.ie_cancelamento::text, '') = ''
		and 	coalesce(b.dt_convenio,clock_timestamp()) >= (clock_timestamp() - nr_mes_conta_disp_pg_w * 30) 
		and 	coalesce(a.dt_mesano_referencia,clock_timestamp()) >= (clock_timestamp() - nr_mes_conta_disp_w * 30)
		and 	a.cd_convenio_parametro = cd_convenio_w
		and (
				b.cd_autorizacao 	= nr_doc_convenio_w 
			or 	a.nr_interno_conta 	= nr_doc_convenio_w 
			or 	a.nr_atendimento    	= nr_doc_convenio_w )
		and 	a.cd_estabelecimento 	= cd_estab_w;

               	if (nr_conta_w = '') then
			nr_conta_w := null;
		elsif (coalesce(nr_conta_w,'') <> '') then
			
			select 	sum(vl_pago + vl_glosado + coalesce(vl_desconto,0))
			into STRICT 	vl_pago_total_w
			from 	convenio_retorno_item 
			where 	nr_interno_conta 	= nr_conta_w
			and 	cd_autorizacao 		= nr_doc_convenio_w;
			
			vl_saldo_w := (vl_guia_w - vl_pago_total_w);
		end if;

        if (nr_conta_w = nr_doc_convenio_w) then
            nr_doc_convenio_w := null;
        end if;

	elsif (ie_doc_retorno_w = 'CONTA') then
        
		nr_conta_w 		:= null;
		begin	
			nr_doc_convenio_ww 	:= (nr_doc_convenio_w)::numeric;
			ie_guia_numero_w	:= 'S';
		exception
		when others then
			ie_guia_numero_w	:= 'N';
		end;	
		
		begin
			select 	max(a.nr_titulo),
				max(a.vl_titulo),
				max(a.vl_saldo_titulo),
				max(a.nr_interno_conta)
			into STRICT	nr_titulo_w,
				vl_guia_w,
				vl_saldo_w,
				nr_conta_w
			FROM convenio b, titulo_receber a
LEFT OUTER JOIN convenio_retorno_item d ON (a.nr_titulo = d.nr_titulo)
WHERE a.cd_cgc 		= b.cd_cgc  and b.cd_convenio 		= coalesce(cd_convenio_w,b.cd_convenio) and a.nr_documento 		= nr_doc_convenio_w and a.ie_situacao 		<> 'D' order by 3 desc;
		exception
		when others then
			vl_guia_w	:= null;
			vl_saldo_w 	:= null;
			nr_conta_w	:= null;
		end;			
		
		if (coalesce(nr_titulo_w,'') <> '') then
			if (nr_conta_w = '') then
				nr_conta_w := null;
			elsif (coalesce(nr_conta_w,'') <> '') then
				
				select 	sum(vl_pago + vl_glosado + coalesce(vl_desconto,0))
				into STRICT 	vl_pago_total_w
				from 	convenio_retorno_item 
				where 	nr_titulo 	= nr_titulo_w
				and 	cd_autorizacao 	= nr_doc_convenio_w;
				
				vl_saldo_w := (vl_guia_w - vl_pago_total_w);
			end if;
		end if;
		if (ie_guia_numero_w = 'S') then
			begin
				select 	max(a.nr_interno_conta),
					max(b.vl_guia), 
					max(b.cd_autorizacao)
				into STRICT 	nr_conta_w,
					vl_guia_w,
					nr_doc_convenio_w
				from 	conta_paciente a, 
					conta_paciente_guia b 
				where 	a.nr_interno_conta = b.nr_interno_conta
				and 	a.ie_status_acerto = 2 
				and 	coalesce(a.ie_cancelamento::text, '') = '' 
				and 	coalesce(b.dt_convenio,clock_timestamp()) >= (clock_timestamp() - nr_mes_conta_disp_pg_w * 30) 
				and 	coalesce(a.dt_mesano_referencia,clock_timestamp()) >= (clock_timestamp() - nr_mes_conta_disp_w * 30)
				and 	a.cd_convenio_parametro = cd_convenio_w
				and 	b.nr_interno_conta = nr_doc_convenio_w
				and 	a.cd_estabelecimento = cd_estab_w;
			exception
			when others then
				vl_guia_w		:= null;
				nr_doc_convenio_w	:= null;
				nr_conta_w		:= null;
			end;			
			
			if (nr_conta_w = '') then
				
				nr_conta_w := null;
			
			elsif (coalesce(nr_conta_w,'') <> '') then
				
				select 	sum(vl_pago + vl_glosado + coalesce(vl_desconto,0))
				into STRICT 	vl_pago_total_w
				from 	convenio_retorno_item 
				where 	nr_interno_conta_w	= nr_conta_w;
				
				vl_saldo_w := (vl_guia_w - vl_pago_total_w);
			
			end if;			
		end if;
      	elsif (ie_doc_retorno_w in ('SENHA', 'SENHAGUIA') ) then
		
		begin
			select 	max(a.nr_interno_conta),
				max(b.vl_guia)
			into STRICT 	nr_conta_w,
				vl_guia_w			
			from 	conta_paciente_guia b, 
				atend_categoria_convenio c, 
				conta_paciente a 
			where 	a.nr_interno_conta = b.nr_interno_conta 
			and   	c.nr_atendimento = a.nr_atendimento 
			and  	c.nr_seq_interno = (	SELECT	coalesce(max(nr_seq_interno),0) 
							from 	atend_categoria_convenio d 
							where	d.nr_atendimento 	= a.nr_atendimento 
							and 	dt_inicio_vigencia	= (	select 	max(dt_inicio_vigencia) 
												from 	atend_categoria_convenio x 
												where 	x.nr_atendimento = d.nr_atendimento))
			and 	coalesce(b.dt_convenio,clock_timestamp()) >= (clock_timestamp() - nr_mes_conta_disp_pg_w * 30) 
			and 	coalesce(a.dt_mesano_referencia,clock_timestamp()) >= (clock_timestamp() - nr_mes_conta_disp_w * 30)
			and 	a.cd_convenio_parametro = cd_convenio_w
			and 	a.ie_status_acerto = 2 
			and 	coalesce(a.ie_cancelamento::text, '') = ''
			and 	c.cd_senha = nr_doc_convenio_w
			and 	a.cd_estabelecimento = cd_estab_w;
		exception
		when others then
			nr_conta_w		:= null;
			vl_guia_w		:= null;
		end;			

		if (nr_conta_w = '') then
				
			nr_conta_w := null;
			
		elsif (coalesce(nr_conta_w,'') <> '') then
			
			select 	sum(vl_pago + vl_glosado + coalesce(vl_desconto,0))
			into STRICT 	vl_pago_total_w
			from 	convenio_retorno_item 
			where 	nr_interno_conta_w	= nr_conta_w;
			
			vl_saldo_w := (vl_guia_w - vl_pago_total_w);
		
		end if;	
	end if;

	ie_glosa_w		:= 'P';
	ie_permite_glosa_w	:= 'N';
	vl_glosado_w		:= 0;
	vl_adicional_w		:= 0;
	vl_amenor_w		:= 0;
	
	if (nr_titulo_w = '') then
		nr_titulo_w := null;
	end if;
	
	if (vl_pago_w > vl_saldo_w) then
		vl_adicional_w 	:= vl_pago_w - vl_saldo_w;
		vl_pago_w 	:= vl_pago_w - vl_adicional_w;
	end if;
	
	SELECT * FROM valida_glosa_conta(	nr_conta_w, vl_saldo_w, vl_saldo_w - vl_pago_w, obter_perfil_ativo(), nm_usuario_w, ie_glosa_w, cd_motivo_w ) INTO STRICT ie_glosa_w, cd_motivo_w;
	
	if (ie_glosa_w = 'S') then
		ie_permite_glosa_w := 'S';
	end if;
	
	if	(vl_glosado_w = 0 AND vl_amenor_w = 0)
	or	(ie_permite_glosa_w = 'N' AND ie_glosa_pend_amenor_w = 'N') then
		ie_glosa_w := 'N';
	elsif	((ie_permite_glosa_w = 'N') and (ie_glosa_pend_amenor_w = 'S') and (vl_amenor_w <> 0)) then
		ie_glosa_w := 'P';
	elsif (ie_permite_glosa_w = 'S') then
		ie_glosa_w := 'S';
	end if;
	
	if (nr_conta_w = '') then
		nr_conta_w := null;
	end if;					
	
	select 	count(1)
	into STRICT	qt_w
	from  	convenio_retorno_item 
	where  	nr_seq_retorno    = nr_seq_retorno_p
	and    	nr_interno_conta  = nr_conta_w;
	
	if (ie_imp_guia_duplicada_w = 'S' AND qt_w > 0) then
		CALL Gravar_convenio_retorno_imp(	nr_seq_retorno_p,
						nr_doc_convenio_w,
						vl_pago_w,
						vl_adicional_w,
						nr_conta_w,
						nm_usuario_w);
	elsif (ie_gerar_movto_w = 'S') then
		insert into convenio_retorno_movto(nr_sequencia, nr_seq_retorno, vl_pago, vl_glosa,
			dt_atualizacao, nm_usuario, nr_doc_convenio,  vl_total_pago,
			nr_conta, cd_autorizacao, cd_motivo, ds_complemento)
		values (nextval('convenio_retorno_movto_seq'), nr_seq_retorno_p, vl_pago_w, vl_glosado_w,
			clock_timestamp(), nm_usuario_w, nr_doc_convenio_w, vl_pago_w,
			nr_conta_w, nr_doc_convenio_w, null, null);
	end if;
		
end loop;
close C01;

delete from w_conv_ret_movto
where nr_seq_retorno  = nr_seq_retorno_p;

commit;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dbf_gerar_w_conv_ret_movto (nr_seq_retorno_p bigint) FROM PUBLIC;
