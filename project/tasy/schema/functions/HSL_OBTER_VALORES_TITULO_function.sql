-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsl_obter_valores_titulo ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

					 
/*ie_opcao_p: 
R = Recebidos 
D = Descontos 
A = Abatimentos 
DM = Desconto Médico, 
P = Perdas 
S = Saldo*/
 
 
vl_retorno_w      		double precision:= 0;
vl_retorno_tit_w    		double precision:= 0;
nr_titulo_w       	bigint;
nr_seq_protocolo_w		bigint;
vl_recebido_w			double precision;
ie_tipo_convenio_w		bigint;

 
c01 CURSOR FOR 
    SELECT /*+ index (a titrece_proconv_fk_i) */ 
		nr_titulo 
	from titulo_receber a 
	where (nr_seq_protocolo_w <> 0) 
	 and (nr_seq_protocolo = nr_seq_protocolo_w) 
	
union
 
	SELECT /*+ index (a titrece_conpaci_fk_i) */ 
		nr_titulo 
	from titulo_receber a 
	where (nr_interno_conta_p <> 0) 
	 and (nr_interno_conta = nr_interno_conta_p);


BEGIN 
 
select 	coalesce(max(nr_seq_protocolo),0), 
	max(obter_tipo_convenio(cd_convenio_parametro)) 
into STRICT	nr_seq_protocolo_w, 
	ie_tipo_convenio_w 
from 	conta_paciente 
where 	nr_interno_conta = nr_interno_conta_p;
 
if (ie_opcao_p = 'R') then -- Recebido 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
		 
		if (ie_tipo_convenio_w = 1) then /* Particular */
 
 
			select coalesce(sum(vl_recebido),0) 
			into STRICT  vl_retorno_tit_w 
			from  titulo_receber_liq 
			where  nr_titulo = nr_titulo_w 
			and	cd_tipo_recebimento not in (4,7,8,9,14,20,21);
		 
		else 
		 
			select 	coalesce(sum(w.vl_recebido),0) 
			into STRICT	vl_retorno_tit_w 
			from ( 
				SELECT	sum(coalesce(b.VL_RECEBIDO,0)) VL_RECEBIDO 
				from	convenio_retorno c, 
					titulo_receber_liq b, 
					convenio_retorno_item a 
				where	a.nr_sequencia		= b.nr_seq_ret_item 
				and	a.nr_seq_retorno	= c.nr_sequencia 
				and	a.nr_interno_conta	= nr_interno_conta_p 
				and	a.nr_titulo = nr_titulo_w) w;
				 
		end if;
 
	    vl_retorno_w := vl_retorno_w + vl_retorno_tit_w;
	    end;
	END LOOP;
	CLOSE c01;
	end;
elsif (ie_opcao_p = 'G') then -- Glosa Retorno 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
		 
		if (ie_tipo_convenio_w <> 1) then /* Nao tem glosa no particular*/
 
 
			select 	coalesce(sum(w.vl_recebido),0) 
			into STRICT	vl_retorno_tit_w 
			from (				 
				SELECT	sum(coalesce(b.vl_glosa,0)) VL_RECEBIDO 
				from	lote_audit_hist c, 
					titulo_receber_liq b, 
					lote_audit_hist_guia a 
				where	a.nr_sequencia		= b.nr_seq_lote_hist_guia 
				and	a.nr_interno_conta	= nr_interno_conta_p 
				and	a.nr_seq_lote_hist	= c.nr_sequencia) w;
				 
		end if;
 
	    vl_retorno_w := vl_retorno_w + vl_retorno_tit_w;
	    end;
	END LOOP;
	CLOSE c01;
	end;
elsif (ie_opcao_p = 'D') then 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
 
	    select coalesce(sum(vl_descontos),0) 
	    into STRICT  vl_retorno_tit_w 
	    from  titulo_receber_liq 
	    where  nr_titulo = nr_titulo_w 
		and	cd_tipo_recebimento not in (4,20,21) 
		having 	coalesce(sum(vl_descontos),0) > 0;
		-- Retirado a linha abaixo e incluído a linha acima, conforme conversado com Cláudia OS 153518 
		--and	cd_tipo_recebimento = 7; 
 
	    vl_retorno_w := vl_retorno_w + vl_retorno_tit_w;
	    end;
	END LOOP;
	CLOSE c01;	
	end;
elsif (ie_opcao_p = 'A') then 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
 
	    select coalesce(sum(vl_descontos),0) 
	    into STRICT  vl_retorno_tit_w 
	    from  titulo_receber_liq 
	    where  nr_titulo = nr_titulo_w 
		and	cd_tipo_recebimento in (4,20,21);
		 
	    vl_retorno_w := vl_retorno_w + vl_retorno_tit_w;
	    end;
	END LOOP;
	CLOSE c01;
	end;
elsif (ie_opcao_p = 'DM') then 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
 
	    select coalesce(sum(vl_descontos),0) 
	    into STRICT  vl_retorno_tit_w 
	    from  titulo_receber_liq 
	    where  nr_titulo = nr_titulo_w 
		and	cd_tipo_recebimento not in (4,8,14,20,21);
		 
	    vl_retorno_w := vl_retorno_w + vl_retorno_tit_w;
	    end;
	END LOOP;
	CLOSE c01;
	end;
elsif (ie_opcao_p = 'P') then 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
 
	    select coalesce(sum(vl_descontos),0) 
	    into STRICT  vl_retorno_tit_w 
	    from  titulo_receber_liq 
	    where  nr_titulo = nr_titulo_w 
		and	cd_tipo_recebimento = 14;
		 
	    vl_retorno_w := vl_retorno_w + vl_retorno_tit_w;
	    end;
	END LOOP;
	CLOSE c01;
	end;
elsif (ie_opcao_p = 'S') then -- GLosa Aberto 
	begin 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
	    nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	    begin 
	    vl_retorno_tit_w:= 0;
		vl_recebido_w	:= 0;
 
		if (ie_tipo_convenio_w = 1) then /* Particular */
 
			/* OS 261794 Definido em conexão com Cláudia*/
 
			select coalesce(sum(vl_saldo_titulo),0) 
			into STRICT  vl_retorno_tit_w 
			from  titulo_receber 
			where  nr_titulo = nr_titulo_w;
		else 
			select 	coalesce(sum(w.vl_conta),0) 
			into STRICT	vl_retorno_tit_w 
			from (	 
				SELECT coalesce(sum(b.vl_conta),0) vl_conta 
				from  pessoa_fisica e, 
					atend_categoria_convenio d, 
					atendimento_paciente c, 
					conta_paciente b, 
					titulo_receber a 
				where  a.nr_titulo     = nr_titulo_w 
				and   a.nr_interno_conta  = b.nr_interno_conta 
				and 	b.nr_interno_conta  = nr_interno_conta_p 
				and   b.nr_atendimento   = c.nr_atendimento 
				and   c.nr_atendimento   = d.nr_atendimento 
				and   obter_atecaco_atendimento(d.nr_atendimento) = d.nr_seq_interno 
				and   c.cd_pessoa_fisica  = e.cd_pessoa_fisica 
				
union
 
				SELECT coalesce(sum(c.vl_conta),0) vl_conta 
				from  pessoa_fisica f, 
					atend_categoria_convenio e, 
					atendimento_paciente d, 
					conta_paciente c, 
					protocolo_convenio b, 
					titulo_receber a 
				where  a.nr_titulo       = nr_titulo_w 
				and   coalesce(a.nr_interno_conta::text, '') = ''		 
				and 	c.nr_interno_conta  = nr_interno_conta_p			 
				and   a.nr_seq_protocolo   = b.nr_seq_protocolo 
				and   b.nr_seq_protocolo   = c.nr_seq_protocolo 
				and   c.nr_atendimento    = d.nr_atendimento 
				and   d.nr_atendimento    = e.nr_atendimento 
				and   obter_atecaco_atendimento(e.nr_atendimento) = e.nr_seq_interno 
				and   d.cd_pessoa_fisica   = f.cd_pessoa_fisica 
				) w;	
 
			select 	coalesce(sum(w.vl_recebido),0) 
			into STRICT	vl_recebido_w 
			from ( 
				SELECT	sum(coalesce(b.VL_RECEBIDO,0)) VL_RECEBIDO 
				from	convenio_retorno c, 
					titulo_receber_liq b, 
					convenio_retorno_item a 
				where	a.nr_sequencia		= b.nr_seq_ret_item 
				and	a.nr_seq_retorno	= c.nr_sequencia 
				and	a.nr_interno_conta	= nr_interno_conta_p 
				and	a.nr_titulo = nr_titulo_w 
				
union
 
				SELECT	sum(coalesce(b.vl_glosa,0)) VL_RECEBIDO 
				from	lote_audit_hist c, 
					titulo_receber_liq b, 
					lote_audit_hist_guia a 
				where	a.nr_sequencia		= b.nr_seq_lote_hist_guia 
				and	a.nr_interno_conta	= nr_interno_conta_p 
				and	a.nr_seq_lote_hist	= c.nr_sequencia) w;
				 
		end if;
			 
	    vl_retorno_w := vl_retorno_w + (vl_retorno_tit_w - vl_recebido_w);
	    end;
	END LOOP;
	CLOSE c01;
	end;
end if;
 
return vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsl_obter_valores_titulo ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;
